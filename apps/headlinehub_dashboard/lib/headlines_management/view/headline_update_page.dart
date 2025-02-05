import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headlinehub_dashboard/headlines_management/bloc/headlines_management_bloc.dart';
import 'package:headlines_repository/headlines_repository.dart';

class HeadlineUpdatePage extends StatelessWidget {
  const HeadlineUpdatePage({super.key, required this.headline});

  final Headline headline;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HeadlinesManagementBloc(context.read<HeadlinesRepository>()),
      child: _HeadlineUpdateView(headline: headline),
    );
  }
}

class _HeadlineUpdateView extends StatelessWidget {
  const _HeadlineUpdateView({required this.headline});

  final Headline headline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Headline')),
      body: BlocListener<HeadlinesManagementBloc, HeadlinesManagementState>(
        listenWhen: (previous, current) =>
            current.updateStatus == HeadlinesManagementStatus.loading,
        listener: (context, state) => Navigator.of(context).pop(),
        child: _HeadlineEditForm(
          headline: headline,
        ),
      ),
    );
  }
}

class _HeadlineEditForm extends StatefulWidget {
  const _HeadlineEditForm({required this.headline});

  final Headline headline;

  @override
  _HeadlineEditFormState createState() => _HeadlineEditFormState();
}

class _HeadlineEditFormState extends State<_HeadlineEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _publishedAtController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.headline.title);
    _contentController = TextEditingController(text: widget.headline.content);
    _imageUrlController = TextEditingController(text: widget.headline.imageUrl);
    _publishedAtController = TextEditingController(
        text: widget.headline.publishedAt.toIso8601String());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _publishedAtController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _publishedAtController.text = picked.toIso8601String();
      });
    }
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedHeadline = widget.headline.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: _imageUrlController.text,
        publishedAt: DateTime.parse(_publishedAtController.text),
      );
      context.read<HeadlinesManagementBloc>().add(
            HeadlineUpdateRequested(updatedHeadline),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title cannot be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Content cannot be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Image URL cannot be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _publishedAtController,
              decoration: const InputDecoration(
                labelText: 'Published At',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Published At cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('Update Headline'),
            ),
          ],
        ),
      ),
    );
  }
}
