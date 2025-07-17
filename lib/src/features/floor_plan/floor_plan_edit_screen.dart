import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'floor_plan_provider.dart';
import 'models/floor_plan.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/result.dart';

class FloorPlanEditScreen extends ConsumerStatefulWidget {
  final int floorPlanId;
  final bool isEditMode;

  const FloorPlanEditScreen({
    super.key,
    required this.floorPlanId,
    this.isEditMode = false,
  });

  @override
  ConsumerState<FloorPlanEditScreen> createState() => _FloorPlanEditScreenState();
}

class _FloorPlanEditScreenState extends ConsumerState<FloorPlanEditScreen> {
  late FloorPlan _floorPlan;
  List<TablePosition> _tablePositions = [];
  bool _isLoading = true;
  String? _error;
  
  // Edit mode variables
  TablePosition? _selectedTable;
  Offset? _dragStartPosition;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _loadFloorPlan();
  }

  Future<void> _loadFloorPlan() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ref.read(floorPlanWithTablesProvider(widget.floorPlanId).future);
      
      if (result.isSuccess) {
        setState(() {
          _floorPlan = result.data;
          _tablePositions = result.data.tables ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result.errorMessage;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Floor Plan Editor'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadFloorPlan,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit ${_floorPlan.name}' : _floorPlan.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (widget.isEditMode) ...[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveChanges,
              tooltip: 'Save Changes',
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Cancel',
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _enterEditMode(),
              tooltip: 'Edit Floor Plan',
            ),
            IconButton(
              icon: const Icon(Icons.add_location),
              onPressed: () => _showAddTableDialog(),
              tooltip: 'Add Table',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Floor Plan Info Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(Icons.map, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _floorPlan.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_floorPlan.width} × ${_floorPlan.height} pixels • ${_tablePositions.length} tables',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (widget.isEditMode)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'EDIT MODE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Floor Plan Canvas
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    // Background Image (if available)
                    if (_floorPlan.backgroundImage != null)
                      Positioned.fill(
                        child: Image.network(
                          _floorPlan.backgroundImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.map_outlined, size: 48, color: Colors.grey),
                        ),
                      ),
                    
                    // Table Positions
                    ..._tablePositions.map((table) => _buildTableWidget(table)),
                    
                    // Add Table Button (in edit mode)
                    if (widget.isEditMode)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: _showAddTableDialog,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Table Status Legend
          if (!widget.isEditMode) _buildStatusLegend(),
        ],
      ),
    );
  }

  Widget _buildTableWidget(TablePosition table) {
    final isSelected = _selectedTable?.id == table.id;
    final statusColor = _getStatusColor(table.tableStatus);

    return Positioned(
      left: table.x.toDouble(),
      top: table.y.toDouble(),
      child: GestureDetector(
        onTap: () => _onTableTap(table),
        onPanStart: widget.isEditMode ? (details) => _onDragStart(table, details) : null,
        onPanUpdate: widget.isEditMode ? (details) => _onDragUpdate(details) : null,
        onPanEnd: widget.isEditMode ? (details) => _onDragEnd() : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: table.width.toDouble(),
          height: table.height.toDouble(),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.8),
            border: Border.all(
              color: isSelected ? Colors.blue : statusColor,
              width: isSelected ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Transform.rotate(
            angle: table.rotation * 3.14159 / 180, // Convert degrees to radians
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    table.tableNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${table.tableCapacity}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.isEditMode)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'DRAG',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Table Status',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            children: [
              _buildLegendItem('Available', Colors.green),
              _buildLegendItem('Occupied', Colors.red),
              _buildLegendItem('Reserved', Colors.orange),
              _buildLegendItem('Cleaning', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String status, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          status,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _onTableTap(TablePosition table) {
    if (widget.isEditMode) {
      setState(() {
        _selectedTable = _selectedTable?.id == table.id ? null : table;
      });
    } else {
      _showTableDetails(table);
    }
  }

  void _onDragStart(TablePosition table, DragStartDetails details) {
    setState(() {
      _selectedTable = table;
      _dragStartPosition = details.localPosition;
      _isDragging = true;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_selectedTable != null && _dragStartPosition != null) {
      setState(() {
        final newX = (_selectedTable!.x + details.delta.dx).round();
        final newY = (_selectedTable!.y + details.delta.dy).round();
        
        // Constrain to floor plan boundaries
        final maxX = _floorPlan.width - _selectedTable!.width;
        final maxY = _floorPlan.height - _selectedTable!.height;
        
        _selectedTable = _selectedTable!.copyWith(
          x: newX.clamp(0, maxX),
          y: newY.clamp(0, maxY),
        );
        
        // Update the table in the list
        final index = _tablePositions.indexWhere((t) => t.id == _selectedTable!.id);
        if (index != -1) {
          _tablePositions[index] = _selectedTable!;
        }
      });
    }
  }

  void _onDragEnd() {
    setState(() {
      _isDragging = false;
      _dragStartPosition = null;
    });
    
    // Auto-save the position change
    if (_selectedTable != null) {
      _saveTablePosition(_selectedTable!);
    }
  }

  Future<void> _saveTablePosition(TablePosition table) async {
    final result = await ref.read(floorPlanNotifierProvider.notifier).updateTablePosition(
      widget.floorPlanId,
      table.id,
      {
        'x': table.x,
        'y': table.y,
      },
    );

    if (result.isSuccess) {
      // Position saved successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Table ${table.tableNumber} position saved'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save position: ${result.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showTableDetails(TablePosition table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Table ${table.tableNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Number', table.tableNumber),
            _buildDetailRow('Capacity', '${table.tableCapacity} seats'),
            _buildDetailRow('Status', table.tableStatus),
            _buildDetailRow('Section', table.tableSection),
            _buildDetailRow('Position', '(${table.x}, ${table.y})'),
            _buildDetailRow('Size', '${table.width} × ${table.height}'),
            if (table.rotation != 0) _buildDetailRow('Rotation', '${table.rotation}°'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (widget.isEditMode)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editTablePosition(table);
              },
              child: const Text('Edit'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _enterEditMode() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FloorPlanEditScreen(
          floorPlanId: widget.floorPlanId,
          isEditMode: true,
        ),
      ),
    );
  }

  void _showAddTableDialog() {
    final xController = TextEditingController(text: '100');
    final yController = TextEditingController(text: '100');
    final widthController = TextEditingController(text: '80');
    final heightController = TextEditingController(text: '80');
    final rotationController = TextEditingController(text: '0');
    int? selectedTableId;

    // Get available tables that aren't already on this floor plan
    final allTablesState = ref.read(allTablesProvider);
    final allTables = allTablesState.when(
      data: (result) => result.isSuccess ? result.data : [],
      loading: () => [],
      error: (_, __) => [],
    );

    // Filter out tables that are already positioned on this floor plan
    final availableTables = allTables.where((table) {
      final tableId = table['id'] as int?;
      if (tableId == null) return false;
      
      // Check if this table is already positioned on this floor plan
      return !_tablePositions.any((position) => position.tableId == tableId);
    }).toList();

    if (availableTables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available tables to add to this floor plan'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Table to ${_floorPlan.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedTableId,
                  decoration: const InputDecoration(
                    labelText: 'Select Table *',
                  ),
                  items: availableTables.map((table) {
                    final tableId = table['id'] as int?;
                    final tableNumber = table['tableNumber']?.toString() ?? 'Unknown';
                    final capacity = table['capacity']?.toString() ?? '0';
                    final section = table['section']?.toString() ?? 'Unknown';
                    
                    return DropdownMenuItem(
                      value: tableId,
                      child: Text('Table $tableNumber ($capacity seats, $section)'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTableId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Position (pixels)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: xController,
                        decoration: const InputDecoration(
                          labelText: 'X Coordinate',
                          hintText: '100',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: yController,
                        decoration: const InputDecoration(
                          labelText: 'Y Coordinate',
                          hintText: '100',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Size (pixels)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widthController,
                        decoration: const InputDecoration(
                          labelText: 'Width',
                          hintText: '80',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: heightController,
                        decoration: const InputDecoration(
                          labelText: 'Height',
                          hintText: '80',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: rotationController,
                  decoration: const InputDecoration(
                    labelText: 'Rotation (degrees)',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedTableId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a table'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final x = int.tryParse(xController.text.trim());
                final y = int.tryParse(yController.text.trim());
                final width = int.tryParse(widthController.text.trim());
                final height = int.tryParse(heightController.text.trim());
                final rotation = int.tryParse(rotationController.text.trim()) ?? 0;

                if (x == null || y == null || width == null || height == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid position and size values'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop();
                _addTableToFloorPlan(selectedTableId!, {
                  'tableId': selectedTableId,
                  'x': x,
                  'y': y,
                  'width': width,
                  'height': height,
                  'rotation': rotation,
                });
              },
              child: const Text('Add Table'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addTableToFloorPlan(int tableId, Map<String, dynamic> positionData) async {
    final result = await ref.read(floorPlanNotifierProvider.notifier).createTablePosition(
      widget.floorPlanId,
      positionData,
    );
    
    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Table added to floor plan successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadFloorPlan(); // Refresh the data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add table to floor plan: ${result.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editTablePosition(TablePosition table) {
    final widthController = TextEditingController(text: table.width.toString());
    final heightController = TextEditingController(text: table.height.toString());
    final rotationController = TextEditingController(text: table.rotation.toString());
    String selectedStatus = table.tableStatus;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit Table ${table.tableNumber}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widthController,
                      decoration: const InputDecoration(
                        labelText: 'Width',
                        hintText: '80',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: heightController,
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        hintText: '80',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: rotationController,
                decoration: const InputDecoration(
                  labelText: 'Rotation (degrees)',
                  hintText: '0',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                items: [
                  DropdownMenuItem(value: 'available', child: Text('Available')),
                  DropdownMenuItem(value: 'occupied', child: Text('Occupied')),
                  DropdownMenuItem(value: 'reserved', child: Text('Reserved')),
                  DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value ?? 'available';
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final width = int.tryParse(widthController.text.trim());
                final height = int.tryParse(heightController.text.trim());
                final rotation = int.tryParse(rotationController.text.trim()) ?? 0;

                if (width == null || width <= 0 || height == null || height <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid width and height'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop();
                _updateTablePosition(table, {
                  'width': width,
                  'height': height,
                  'rotation': rotation,
                });
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateTablePosition(TablePosition table, Map<String, dynamic> data) async {
    final result = await ref.read(floorPlanNotifierProvider.notifier).updateTablePosition(
      widget.floorPlanId,
      table.id,
      data,
    );

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Table position updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadFloorPlan(); // Refresh the data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update table position: ${result.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveChanges() async {
    // Save all changes made in edit mode
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Exit edit mode
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FloorPlanEditScreen(
          floorPlanId: widget.floorPlanId,
          isEditMode: false,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'occupied':
        return Colors.red;
      case 'reserved':
        return Colors.orange;
      case 'cleaning':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
} 