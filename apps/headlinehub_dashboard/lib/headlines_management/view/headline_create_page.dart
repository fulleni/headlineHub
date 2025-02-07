import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headlinehub_dashboard/headlines_management/bloc/headlines_management_bloc.dart';
import 'package:headlines_repository/headlines_repository.dart';

class HeadlineCreatePage extends StatelessWidget {
  const HeadlineCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HeadlinesManagementBloc(context.read<HeadlinesRepository>()),
      child: const _HeadlineCreateView(),
    );
  }
}

class _HeadlineCreateView extends StatelessWidget {
  const _HeadlineCreateView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Headline')),
      body: BlocListener<HeadlinesManagementBloc, HeadlinesManagementState>(
        listener: (context, state) {
          if (state.createStatus == HeadlinesManagementStatus.failure) {
            Navigator.of(context).pop(false);
          }
          if (state.createStatus == HeadlinesManagementStatus.success) {
            Navigator.of(context).pop(true);
          }
        },
        child: const _HeadlineCreationForm(),
      ),
    );
  }
}

class _HeadlineCreationForm extends StatefulWidget {
  const _HeadlineCreationForm();

  @override
  _HeadlineCreationFormState createState() => _HeadlineCreationFormState();
}

class _HeadlineCreationFormState extends State<_HeadlineCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _publishedAtController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _publishedAtController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
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
      final headline = Headline(
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: _imageUrlController.text,
        publishedBy: const Source(
          id: 'source_11',
          name: 'Scientific North Korean',
          description: 'Advancing science and technology',
          url: 'https://www.scientificamerican.com',
          language: Language(code: 'en', name: 'English'),
          country: Country(
            code: 'NK',
            name: 'North Korea',
            flagUrl: 'https://www.scientificamerican.com/flag.png',
          ),
        ),
        publishedAt: DateTime.parse(_publishedAtController.text),
        happenedIn: const Country(
          code: 'NK',
          name: 'North Korea',
          flagUrl: 'https://www.scientificamerican.com/flag.png',
        ),
        language: const Language(code: 'en', name: 'English'),
      );
      context.read<HeadlinesManagementBloc>().add(
            HeadlineCreateRequested(headline),
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
              child: const Text('Create Headline'),
            ),
          ],
        ),
      ),
    );
  }
}
