import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import '../../core/theme/theme_provider.dart';
import '../auth/models/user.dart';
import '../auth/auth_provider.dart';
import 'admin_menu_provider.dart';
import 'pdf_menu_provider.dart';

class PdfMenuGenerationScreen extends ConsumerStatefulWidget {
  const PdfMenuGenerationScreen({super.key});

  @override
  ConsumerState<PdfMenuGenerationScreen> createState() => _PdfMenuGenerationScreenState();
}

class _PdfMenuGenerationScreenState extends ConsumerState<PdfMenuGenerationScreen> {
  String? _selectedTemplate = 'elegant';
  bool _includePrices = true;
  bool _includeDescriptions = true;
  bool _includeAllergens = true;
  bool _includeCalories = true;
  String _orientation = 'portrait';
  String _fontSize = 'medium';
  String _colorScheme = 'light';
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    // Load templates when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pdfMenuProvider.notifier).loadTemplates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final templatesAsync = ref.watch(pdfMenuProvider);
    
    // Check if user is admin
    if (authState.user?.role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Access Denied'),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Access Denied',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This feature is only available to system administrators.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PDF Menu Generation',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTemplateSelection(theme, templatesAsync),
            const SizedBox(height: 24),
            _buildContentOptions(theme),
            const SizedBox(height: 24),
            _buildLayoutOptions(theme),
            const SizedBox(height: 32),
            _buildGenerateButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateSelection(ThemeData theme, AsyncValue<List<Map<String, String>>> templatesAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Template Selection',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            templatesAsync.when(
              data: (templates) {
                if (templates.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No templates available'),
                    ),
                  );
                }
                
                // Set default template if none selected
                if (_selectedTemplate == null && templates.isNotEmpty) {
                  _selectedTemplate = templates.first['id'];
                }
                
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: templates.map((template) {
                    final isSelected = _selectedTemplate == template['id'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTemplate = template['id'];
                        });
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected 
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : theme.colorScheme.surface,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template['name']!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? theme.colorScheme.primary : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              template['description']!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error,
                        color: theme.colorScheme.error,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load templates',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(pdfMenuProvider.notifier).loadTemplates();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentOptions(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Options',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Include Prices'),
              subtitle: const Text('Show item prices in the menu'),
              value: _includePrices,
              onChanged: (value) {
                setState(() {
                  _includePrices = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Include Descriptions'),
              subtitle: const Text('Show item descriptions'),
              value: _includeDescriptions,
              onChanged: (value) {
                setState(() {
                  _includeDescriptions = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Include Allergens'),
              subtitle: const Text('Show allergen information'),
              value: _includeAllergens,
              onChanged: (value) {
                setState(() {
                  _includeAllergens = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Include Calories'),
              subtitle: const Text('Show calorie information'),
              value: _includeCalories,
              onChanged: (value) {
                setState(() {
                  _includeCalories = value ?? true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutOptions(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Layout Options',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _orientation,
              decoration: const InputDecoration(
                labelText: 'Orientation',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'portrait', child: Text('Portrait')),
                DropdownMenuItem(value: 'landscape', child: Text('Landscape')),
              ],
              onChanged: (value) {
                setState(() {
                  _orientation = value ?? 'portrait';
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _fontSize,
              decoration: const InputDecoration(
                labelText: 'Font Size',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'small', child: Text('Small')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'large', child: Text('Large')),
              ],
              onChanged: (value) {
                setState(() {
                  _fontSize = value ?? 'medium';
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _colorScheme,
              decoration: const InputDecoration(
                labelText: 'Color Scheme',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
                DropdownMenuItem(value: 'auto', child: Text('Auto')),
              ],
              onChanged: (value) {
                setState(() {
                  _colorScheme = value ?? 'light';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : _generatePdf,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: _isGenerating
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Generating PDF...'),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf),
                  SizedBox(width: 8),
                  Text('Generate PDF Menu'),
                ],
              ),
      ),
    );
  }

  void _generatePdf() async {
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a template'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final authState = ref.read(authNotifierProvider);
      final businessId = authState.user?.businessId ?? 1;
      
      final pdfBytes = await ref.read(pdfMenuProvider.notifier).generatePdf(
        businessId: businessId,
        template: _selectedTemplate,
        includePrices: _includePrices,
        includeDescriptions: _includeDescriptions,
        includeAllergens: _includeAllergens,
        includeCalories: _includeCalories,
        orientation: _orientation,
        fontSize: _fontSize,
        colorScheme: _colorScheme,
      );
      
      if (mounted) {
        // Download the PDF
        _downloadPdf(pdfBytes, businessId);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF generated successfully! Size: ${pdfBytes.length} bytes'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _downloadPdf(Uint8List pdfBytes, int businessId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = 'menu-$businessId-$timestamp.pdf';
    
    // Create blob and download
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}