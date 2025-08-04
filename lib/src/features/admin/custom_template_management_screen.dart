import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/localization/app_localizations.dart';
import '../auth/models/user.dart';
import '../auth/auth_provider.dart';
import 'pdf_menu_provider.dart';
import 'models/custom_menu_template.dart';

class CustomTemplateManagementScreen extends ConsumerStatefulWidget {
  const CustomTemplateManagementScreen({super.key});

  @override
  ConsumerState<CustomTemplateManagementScreen> createState() => _CustomTemplateManagementScreenState();
}

class _CustomTemplateManagementScreenState extends ConsumerState<CustomTemplateManagementScreen> {
  List<CustomMenuTemplate> _customTemplates = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCustomTemplates();
  }

  Future<void> _loadCustomTemplates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authState = ref.read(authNotifierProvider);
      final businessId = authState.user?.businessId ?? 1;
      
      final templates = await ref.read(pdfMenuProvider.notifier).getCustomTemplates(businessId);
      setState(() {
        _customTemplates = templates;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    
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
                'This feature is only available to system administrators',
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
          l10n.customTemplateManagement,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _loadCustomTemplates,
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: _buildBody(theme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTemplateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingTemplates,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCustomTemplates,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_customTemplates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noCustomTemplates,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.createYourFirstCustomTemplateToGetStarted,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _customTemplates.length,
      itemBuilder: (context, index) {
        final template = _customTemplates[index];
        return _buildTemplateCard(theme, template);
      },
    );
  }

  Widget _buildTemplateCard(ThemeData theme, CustomMenuTemplate template) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: template.isDefault 
              ? theme.colorScheme.primary 
              : theme.colorScheme.secondary,
          child: Icon(
            template.isDefault ? Icons.star : Icons.description_outlined,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        title: Text(
          template.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(template.description),
            const SizedBox(height: 4),
            Row(
              children: [
                if (template.isActive)
                  Chip(
                    label: Text(l10n.active),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                  ),
                if (template.isDefault)
                  Chip(
                    label: Text(l10n.defaultText),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    labelStyle: TextStyle(color: theme.colorScheme.onSecondaryContainer),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleTemplateAction(value, template),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  const SizedBox(width: 8),
                  Text(l10n.edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'preview',
              child: Row(
                children: [
                  const Icon(Icons.preview),
                  const SizedBox(width: 8),
                  Text(l10n.preview),
                ],
              ),
            ),
            if (!template.isDefault)
              PopupMenuItem(
                value: 'set_default',
                child: Row(
                  children: [
                    const Icon(Icons.star),
                    const SizedBox(width: 8),
                    Text(l10n.setAsDefault),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTemplateAction(String action, CustomMenuTemplate template) {
    switch (action) {
      case 'edit':
        _showEditTemplateDialog(context, template);
        break;
      case 'preview':
        _showPreviewTemplateDialog(context, template);
        break;
      case 'set_default':
        _setAsDefault(template);
        break;
      case 'delete':
        _showDeleteConfirmation(context, template);
        break;
    }
  }

  void _showCreateTemplateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _CreateTemplateDialog(),
    ).then((_) => _loadCustomTemplates());
  }

  void _showEditTemplateDialog(BuildContext context, CustomMenuTemplate template) {
    showDialog(
      context: context,
      builder: (context) => _EditTemplateDialog(template: template),
    ).then((_) => _loadCustomTemplates());
  }

  void _showPreviewTemplateDialog(BuildContext context, CustomMenuTemplate template) {
    showDialog(
      context: context,
      builder: (context) => _PreviewTemplateDialog(template: template),
    );
  }

  Future<void> _setAsDefault(CustomMenuTemplate template) async {
    try {
      final authState = ref.read(authNotifierProvider);
      final businessId = authState.user?.businessId ?? 1;
      
      await ref.read(pdfMenuProvider.notifier).updateCustomTemplate(
        businessId: businessId,
        templateId: template.id,
        isDefault: true,
      );
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${template.name} ${l10n.templateSetAsDefault}'),
            backgroundColor: Colors.green,
          ),
        );
        _loadCustomTemplates();
      }
    } catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorSettingDefaultTemplate} $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context, CustomMenuTemplate template) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTemplate),
        content: Text('${l10n.areYouSureYouWantToDeleteTemplate} "${template.name}"? ${l10n.thisActionCannotBeUndone}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteTemplate(template);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTemplate(CustomMenuTemplate template) async {
    try {
      final authState = ref.read(authNotifierProvider);
      final businessId = authState.user?.businessId ?? 1;
      
      await ref.read(pdfMenuProvider.notifier).deleteCustomTemplate(
        businessId: businessId,
        templateId: template.id,
      );
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${template.name} ${l10n.templateDeletedSuccessfully}'),
            backgroundColor: Colors.green,
          ),
        );
        _loadCustomTemplates();
      }
    } catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorDeletingTemplate} $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Create Template Dialog
class _CreateTemplateDialog extends ConsumerStatefulWidget {
  const _CreateTemplateDialog();

  @override
  ConsumerState<_CreateTemplateDialog> createState() => _CreateTemplateDialogState();
}

class _CreateTemplateDialogState extends ConsumerState<_CreateTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _htmlController = TextEditingController();
  final _cssController = TextEditingController();
  bool _isActive = true;
  bool _isDefault = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _htmlController.dispose();
    _cssController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.createCustomTemplate),
      content: SizedBox(
        width: 600,
        height: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.templateName,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterATemplateName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _htmlController,
                  decoration: InputDecoration(
                    labelText: l10n.htmlContent,
                    border: const OutlineInputBorder(),
                    hintText: l10n.enterHtmlTemplateContent,
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterHtmlContent;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cssController,
                  decoration: InputDecoration(
                    labelText: l10n.cssContent,
                    border: const OutlineInputBorder(),
                    hintText: l10n.enterCssStyles,
                  ),
                  maxLines: 6,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value ?? true;
                        });
                      },
                    ),
                    Text(l10n.active),
                    const SizedBox(width: 16),
                    Checkbox(
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value ?? false;
                        });
                      },
                    ),
                    Text(l10n.setAsDefaultTemplate),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createTemplate,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.create),
        ),
      ],
    );
  }

  Future<void> _createTemplate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authState = ref.read(authNotifierProvider);
      final businessId = authState.user?.businessId ?? 1;
      
      await ref.read(pdfMenuProvider.notifier).createCustomTemplate(
        businessId: businessId,
        name: _nameController.text,
        description: _descriptionController.text,
        htmlContent: _htmlController.text,
        cssContent: _cssController.text,
        isActive: _isActive,
        isDefault: _isDefault,
      );
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.templateCreatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorCreatingTemplate} $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

// Edit Template Dialog
class _EditTemplateDialog extends ConsumerStatefulWidget {
  final CustomMenuTemplate template;

  const _EditTemplateDialog({required this.template});

  @override
  ConsumerState<_EditTemplateDialog> createState() => _EditTemplateDialogState();
}

class _EditTemplateDialogState extends ConsumerState<_EditTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _htmlController;
  late final TextEditingController _cssController;
  late bool _isActive;
  late bool _isDefault;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template.name);
    _descriptionController = TextEditingController(text: widget.template.description);
    _htmlController = TextEditingController(text: widget.template.htmlContent);
    _cssController = TextEditingController(text: widget.template.cssContent);
    _isActive = widget.template.isActive;
    _isDefault = widget.template.isDefault;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _htmlController.dispose();
    _cssController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.editCustomTemplate),
      content: SizedBox(
        width: 600,
        height: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.templateName,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterATemplateName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _htmlController,
                  decoration: InputDecoration(
                    labelText: l10n.htmlContent,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterHtmlContent;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cssController,
                  decoration: InputDecoration(
                    labelText: l10n.cssContent,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 6,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value ?? true;
                        });
                      },
                    ),
                    Text(l10n.active),
                    const SizedBox(width: 16),
                    Checkbox(
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value ?? false;
                        });
                      },
                    ),
                    Text(l10n.setAsDefaultTemplate),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateTemplate,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.update),
        ),
      ],
    );
  }

  Future<void> _updateTemplate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authState = ref.read(authNotifierProvider);
      final businessId = authState.user?.businessId ?? 1;
      
      await ref.read(pdfMenuProvider.notifier).updateCustomTemplate(
        businessId: businessId,
        templateId: widget.template.id,
        name: _nameController.text,
        description: _descriptionController.text,
        htmlContent: _htmlController.text,
        cssContent: _cssController.text,
        isActive: _isActive,
        isDefault: _isDefault,
      );
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.templateUpdatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorUpdatingTemplate} $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

// Preview Template Dialog
class _PreviewTemplateDialog extends StatelessWidget {
  final CustomMenuTemplate template;

  const _PreviewTemplateDialog({required this.template});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text('${l10n.previewTemplate} ${template.name}'),
      content: SizedBox(
        width: 800,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              template.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: l10n.htmlContent),
                        Tab(text: l10n.cssContent),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.colorScheme.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                template.htmlContent,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.colorScheme.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                template.cssContent,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
