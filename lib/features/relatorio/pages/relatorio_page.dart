import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_humor/core/routes/app_router.dart';
import 'package:my_humor/features/home/controllers/home_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../mood_registration/entities/mood_entry.dart';
import '../controllers/relatorio_controller.dart';
import '../utils/save_image_io.dart'
    if (dart.library.html) '../utils/save_image_stub.dart' as save_image;
import '../widgets/mood_line_chart.dart';
import '../widgets/mood_pie_chart.dart';

/// Relatorio page: shown when user has already registered mood for today (N02).
/// PR01–PR06: line chart, filter, export PDF, print/save image, buttons order and alignment.
class RelatorioPage extends ConsumerStatefulWidget {
  const RelatorioPage({super.key});

  @override
  ConsumerState<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends ConsumerState<RelatorioPage> {
  late int _year;
  late int _month;
  final GlobalKey _contentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkIfHasEntryToday());
  }

  Future<void> _seedSampleData() async {
    final repository = ref.read(relatorioRepositoryProvider);
    await repository.seedSampleDataForMonth(_year, _month);
    if (!mounted) return;
    ref.invalidate(relatorioControllerProvider((year: _year, month: _month)));
  }

  Future<void> _clearSampleData() async {
    final repository = ref.read(relatorioRepositoryProvider);
    await repository.clearSampleData();
    if (!mounted) return;
    ref.invalidate(relatorioControllerProvider((year: _year, month: _month)));
  }

  Future<void> _showFilterDialog() async {
    final now = DateTime.now();
    int year = _year;
    int month = _month;
    final result = await showDialog<({int year, int month})>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filtrar por mês/ano'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: month,
                    isExpanded: true,
                    // Quero exibir o nome do mês em português do Brasil
                    items: List.generate(12, (i) => i + 1)
                        .map((m) => DropdownMenuItem(value: m, child: Text(_getMonthName(m))))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => month = v);
                      }
                    },
                  ),
                  DropdownButton<int>(
                    value: year,
                    isExpanded: true,
                    items: List.generate(5, (i) => now.year - i)
                        .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => year = v);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, (year: year, month: month)),
                  child: const Text('Aplicar'),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null && mounted) {
      setState(() {
        _year = result.year;
        _month = result.month;
      });
    }
  }

  Future<void> _exportPdf(List<MoodEntry> entries) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Relatório de humor $_month/$_year',
                  style: pw.TextStyle(fontSize: 18),
                ),
              ),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text('Data'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text('Humor'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text('Observação'),
                      ),
                    ],
                  ),
                  ...entries.map((e) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          '${e.date.day}/${e.date.month}/${e.date.year}',
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(e.moodLevel.label),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(e.observation),
                      ),
                    ],
                  )),
                ],
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      // ignore: unnecessary_brace_in_string_interps
      name: 'relatorio_humor_${_year}_${_month}.pdf',
    );
  }

  Future<void> _saveAsImage() async {
    if (kIsWeb) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Salvar imagem não disponível na versão web.'),
        ),
      );
      return;
    }
    final boundary =
        _contentKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null || !mounted) return;
    final dir = await getApplicationDocumentsDirectory();
    // ignore: unnecessary_brace_in_string_interps
    final path = '${dir.path}/relatorio_${_year}_${_month}.png';
    try {
      await save_image.saveImageBytesToPath(
        byteData.buffer.asUint8List(),
        path,
      );
    } on UnsupportedError {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Salvar imagem não disponível nesta plataforma.'),
        ),
      );
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Imagem salva: $path')),
    );
  }

  String _getMonthName(int month) {
    // Em português do Brasil
    return capitalize(DateFormat('MMMM', 'pt_BR').format(DateTime(0, month)));
  }
  String capitalize(String s) {
    return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
  }

  Future<void> _checkIfHasEntryToday() async {
    final repository = ref.read(moodRepositoryProvider);
    final now = DateTime.now();
    final hasEntryToday = await repository.hasEntryForDate(now);
    if (mounted && !hasEntryToday) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = (year: _year, month: _month);
    final asyncEntries = ref.watch(relatorioControllerProvider(params));
    return Scaffold(
      appBar: AppBar(title: Text('${_getMonthName(_month)} de $_year')),
      body: RepaintBoundary(
        key: _contentKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: asyncEntries.when(
                  data: (entries) {
                    if (entries.isEmpty) {
                      return const Center(
                        child: Text('Nenhum registro neste mês.'),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MoodLineChart(entries: entries),
                          const SizedBox(height: 32),
                          MoodPieChart(entries: entries),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, _) => Center(child: Text('Erro: $err')),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: _showFilterDialog,
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filtrar'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: asyncEntries.hasValue
                        ? () => _exportPdf(asyncEntries.value ?? [])
                        : null,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Exportar'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _saveAsImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Print'),
                  ),
                ],
              ),
            ),
            // const SizedBox(width: 12),
            // FilledButton.icon(
            //   onPressed: _seedSampleData,
            //   icon: const Icon(Icons.data_object),
            //   label: const Text('Gerar dados de exemplo'),
            // ),
            // const SizedBox(width: 12),
            // FilledButton.icon(
            //   onPressed: _clearSampleData,
            //   icon: const Icon(Icons.delete),
            //   label: const Text('Limpar dados de exemplo'),
            // ),
          ],
        ),
      ),
    );
  }
}
