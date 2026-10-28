import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const AlIdarahApp());
}

class AlIdarahApp extends StatelessWidget {
  const AlIdarahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الإدارة - Al-Idarah',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', ''),
      supportedLocales: const [Locale('ar', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.blueAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          centerTitle: true,
          elevation: 0,
        ),
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WordEditorTab(),
    ExcelEditorTab(),
    PdfCenterTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق الإدارة (Al-Idarah)'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1F1F1F),
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'المستندات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'الجداول',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'مركز PDF',
          ),
        ],
      ),
    );
  }
}

class WordEditorTab extends StatefulWidget {
  const WordEditorTab({super.key});

  @override
  State<WordEditorTab> createState() => _WordEditorTabState();
}

class _WordEditorTabState extends State<WordEditorTab> {
  final TextEditingController _textController = TextEditingController();

  void _saveAsPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(
              _textController.text,
              style: const pw.TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'اكتب نص المستند هنا (بدون علامات مائية)...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveAsPdf,
              icon: const Icon(Icons.print),
              label: const Text('طباعة / تصدير كـ PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExcelEditorTab extends StatefulWidget {
  const ExcelEditorTab({super.key});

  @override
  State<ExcelEditorTab> createState() => _ExcelEditorTabState();
}

class _ExcelEditorTabState extends State<ExcelEditorTab> {
  final List<Map<String, String>> _rows = [
    {'item': 'مشتريات', 'amount': '150', 'date': '2026-10-01'},
    {'item': 'مرتبات', 'amount': '1200', 'date': '2026-10-05'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'جدول البيانات والحسابات اليومية',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _rows.length,
              itemBuilder: (context, index) {
                final row = _rows[index];
                return Card(
                  child: ListTile(
                    title: Text('البند: ${row['item']}'),
                    subtitle: Text('التاريخ: ${row['date']}'),
                    trailing: Text(
                      '${row['amount']} د.ل',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PdfCenterTab extends StatelessWidget {
  const PdfCenterTab({super.key});

  Future<void> _pickAndPrintFile() async {
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.picture_as_pdf, size: 80, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            'مركز إدارة ملفات الـ PDF',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'قراءة، دمج، وتعديل ملفات الـ PDF بكل حرية بدون علامات مائية.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _pickAndPrintFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('اختيار ملف PDF من الجهاز'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
