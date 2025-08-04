import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../core/theme/theme_provider.dart';
import '../auth/models/user.dart';
import '../auth/auth_provider.dart';
import 'admin_menu_provider.dart';
import 'pdf_menu_provider.dart';
import 'models/custom_menu_template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import '../../core/localization/app_localizations.dart';

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
  bool _includeItemImages = true; // New option for menu item images
  bool _includeBusinessLogo = true; // New option for business logo
  String _orientation = 'portrait';
  String _fontSize = 'medium';
  String _colorScheme = 'light';
  // New category layout options
  String _categoryLayout = 'same-page';
  String _categoryBackgroundColor = '#0066CC';
  int _maxItemsPerPage = 8;
  bool _isGenerating = false;
  List<CustomMenuTemplate> _customTemplates = [];
  bool _isLoadingCustomTemplates = false;
  
  // Controller for the color text field
  late TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    // Initialize the color controller
    _colorController = TextEditingController(text: _categoryBackgroundColor);
    
    // Load templates when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pdfMenuProvider.notifier).loadTemplates();
      _loadCustomTemplates();
    });
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomTemplates() async {
    setState(() {
      _isLoadingCustomTemplates = true;
    });

    try {
      final authState = ref.read(authNotifierProvider);
      final businessId = authState.user?.businessId ?? 1;
      
      final templates = await ref.read(pdfMenuProvider.notifier).getCustomTemplates(businessId);
      setState(() {
        _customTemplates = templates;
        _isLoadingCustomTemplates = false;
      });
    } catch (error) {
      setState(() {
        _isLoadingCustomTemplates = false;
      });
      // Don't show error for custom templates, just log it
      print('Error loading custom templates: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final templatesAsync = ref.watch(pdfMenuProvider);
    
    // Check if user is admin
    if (authState.user?.role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.accessDenied),
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
                l10n.accessDenied,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.accessDeniedDescription,
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
          l10n.pdfMenuGeneration,
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
            const SizedBox(height: 24),
            _buildCategoryLayoutOptions(theme),
            const SizedBox(height: 32),
            _buildGenerateButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateSelection(ThemeData theme, AsyncValue<List<Map<String, String>>> templatesAsync) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.templateSelection,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            templatesAsync.when(
              data: (templates) {
                if (templates.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noTemplatesAvailable),
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
                        l10n.failedToLoadTemplates,
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
                        child: Text(l10n.retry),
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
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.contentOptions,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
                          title: Text(l10n.includePrices),
            subtitle: Text(l10n.showItemPricesInMenu),
              value: _includePrices,
              onChanged: (value) {
                setState(() {
                  _includePrices = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: Text(l10n.includeDescriptions),
              subtitle: Text(l10n.showItemDescriptions),
              value: _includeDescriptions,
              onChanged: (value) {
                setState(() {
                  _includeDescriptions = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: Text(l10n.includeAllergens),
              subtitle: Text(l10n.showAllergenInformation),
              value: _includeAllergens,
              onChanged: (value) {
                setState(() {
                  _includeAllergens = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: Text(l10n.includeCalories),
              subtitle: Text(l10n.showCalorieInformation),
              value: _includeCalories,
              onChanged: (value) {
                setState(() {
                  _includeCalories = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: Text(l10n.includeItemImages),
              subtitle: Text(l10n.showMenuItemImagesInPdf),
              value: _includeItemImages,
              onChanged: (value) {
                setState(() {
                  _includeItemImages = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: Text(l10n.includeBusinessLogo),
              subtitle: Text(l10n.showBusinessLogoInPdfHeader),
              value: _includeBusinessLogo,
              onChanged: (value) {
                setState(() {
                  _includeBusinessLogo = value ?? true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutOptions(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.layoutOptions,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _orientation,
              decoration: InputDecoration(
                labelText: l10n.orientation,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'portrait', child: Text(l10n.portrait)),
                DropdownMenuItem(value: 'landscape', child: Text(l10n.landscape)),
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
              decoration: InputDecoration(
                labelText: l10n.fontSize,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'small', child: Text(l10n.small)),
                DropdownMenuItem(value: 'medium', child: Text(l10n.medium)),
                DropdownMenuItem(value: 'large', child: Text(l10n.large)),
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
              decoration: InputDecoration(
                labelText: l10n.colorScheme,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'light', child: Text(l10n.light)),
                DropdownMenuItem(value: 'dark', child: Text(l10n.dark)),
                DropdownMenuItem(value: 'auto', child: Text(l10n.auto)),
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

  Widget _buildCategoryLayoutOptions(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.categoryLayoutOptions,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _categoryLayout,
              decoration: InputDecoration(
                labelText: l10n.categoryLayout,
                border: const OutlineInputBorder(),
                helperText: l10n.howCategoriesAreOrganizedInPdf,
              ),
              items: [
                DropdownMenuItem(
                  value: 'same-page',
                  child: Text(l10n.samePageCategoryItemsTogether),
                ),
                DropdownMenuItem(
                  value: 'separate-page',
                  child: Text(l10n.separatePageCategoryTitlePageItemsPages),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _categoryLayout = value ?? 'same-page';
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _colorController,
                    decoration: InputDecoration(
                      labelText: l10n.categoryBackgroundColor,
                      border: const OutlineInputBorder(),
                      helperText: l10n.hexColorCodeExample,
                      prefixIcon: const Icon(Icons.palette),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _categoryBackgroundColor = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _parseHexColor(_categoryBackgroundColor),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => _showColorPicker(context),
                      child: Icon(
                        Icons.colorize,
                        color: _parseHexColor(_categoryBackgroundColor).computeLuminance() > 0.5 
                            ? Colors.black 
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _maxItemsPerPage.toString(),
                    decoration: InputDecoration(
                      labelText: l10n.maxItemsPerPage,
                      border: const OutlineInputBorder(),
                      helperText: l10n.defaultColon + ' 8',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _maxItemsPerPage = int.tryParse(value) ?? 8;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
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
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.generatingPdf),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf),
                  const SizedBox(width: 8),
                  Text(l10n.generatePdfMenu),
                ],
              ),
      ),
    );
  }

  void _generatePdf() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseSelectTemplate),
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
        includeItemImages: _includeItemImages,
        includeBusinessLogo: _includeBusinessLogo,
        orientation: _orientation,
        fontSize: _fontSize,
        colorScheme: _colorScheme,
        categoryLayout: _categoryLayout,
        categoryBackgroundColor: _categoryBackgroundColor,
        maxItemsPerPage: _maxItemsPerPage,
      );
      
      if (mounted) {
        // Download the PDF
        _downloadPdf(pdfBytes, businessId);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.pdfGeneratedSuccessfully} ${pdfBytes.length} ${l10n.bytes}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorGeneratingPdf} $error'),
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

  void _downloadPdf(Uint8List pdfBytes, int businessId) async {
    final l10n = AppLocalizations.of(context)!;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = 'menu-$businessId-$timestamp.pdf';
    
    if (kIsWeb) {
      // Web platform - use HTML download
      _downloadPdfWeb(pdfBytes, filename);
    } else {
      // Mobile platform - use file system
      await _downloadPdfMobile(pdfBytes, filename);
    }
  }

  void _downloadPdfWeb(Uint8List pdfBytes, String filename) {
    // Web implementation - use universal_html package or show message
    final blob = html.Blob([pdfBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..style.display = 'none'
      ..download = filename;
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _downloadPdfMobile(Uint8List pdfBytes, String filename) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');

      await file.writeAsBytes(pdfBytes);

      // Request storage permissions for Android
      final status = await Permission.storage.request();
      final externalStatus = await Permission.manageExternalStorage.request();
      
      if (status.isGranted || externalStatus.isGranted) {
        await OpenFile.open(file.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.permissionDeniedToOpenFile),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error downloading PDF on mobile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorDownloadingPdf),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showColorPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color currentColor = _parseHexColor(_categoryBackgroundColor);
    Color selectedColor = currentColor; // Local state for the picker
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.pickCategoryBackgroundColor),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (color) {
                    setDialogState(() {
                      selectedColor = color;
                    });
                  },
                  enableAlpha: false,
                  displayThumbColor: true,
                  labelTypes: const [],
                  pickerAreaHeightPercent: 0.8,
                  pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(4)),
                  showLabel: false,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(l10n.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(l10n.ok),
                  onPressed: () {
                    setState(() {
                      // Extract only RGB values (without alpha) and convert to hex
                      final red = selectedColor.red.toRadixString(16).padLeft(2, '0');
                      final green = selectedColor.green.toRadixString(16).padLeft(2, '0');
                      final blue = selectedColor.blue.toRadixString(16).padLeft(2, '0');
                      _categoryBackgroundColor = '#$red$green$blue';
                      _colorController.text = _categoryBackgroundColor;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _parseHexColor(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.isEmpty) return Colors.grey;
      
      // Handle 3-digit hex (e.g., "f8f" -> "f8f8f8")
      if (hex.length == 3) {
        hex = hex.split('').map((char) => char + char).join();
      }
      
      // Handle 6-digit hex (add alpha)
      if (hex.length == 6) {
        hex = 'FF' + hex;
      }
      
      // Validate length
      if (hex.length != 8) {
        return Colors.grey;
      }
      
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      print('Error parsing hex color: $hex - $e');
      return Colors.grey;
    }
  }
}
