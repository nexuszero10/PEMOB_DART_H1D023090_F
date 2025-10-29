import 'package:studi_kasus_statistika_dart/studi_kasus_statistika_dart.dart'
    as studi_kasus_statistika_dart;

import 'dart:io';
import 'dart:math';

void main() {
  print('=== PROGRAM STATISTIK LENGKAP ===');
  stdout.write('Masukkan deret angka (pisahkan dengan spasi): ');
  List<double> data = stdin
      .readLineSync()!
      .split(' ')
      .where((e) => e.trim().isNotEmpty)
      .map((e) => double.parse(e))
      .toList();

  while (true) {
    print('\n=== MENU OPERASI STATISTIK ===');
    print('1. Rata-rata (Mean)');
    print('2. Median');
    print('3. Modus');
    print('4. Deviasi Standar');
    print('5. Variansi (Variance)');
    print('6. Range (Jangkauan)');
    print('7. Kuartil (Q1, Q2, Q3)');
    print('8. Persentil (custom)');
    print('9. Keluar');
    stdout.write('Masukkan pilihan [1-9]: ');
    String? pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        print('\nRata-rata: ${hitungMean(data).toStringAsFixed(2)}');
        break;
      case '2':
        print('\nMedian: ${hitungMedian(data)}');
        break;
      case '3':
        print('\nModus: ${hitungModus(data)}');
        break;
      case '4':
        print('\nDeviasi Standar: ${hitungDeviasi(data).toStringAsFixed(2)}');
        break;
      case '5':
        print('\nVariansi: ${hitungVariansi(data).toStringAsFixed(2)}');
        break;
      case '6':
        print('\nRange: ${hitungRange(data)}');
        break;
      case '7':
        var kuartil = hitungKuartil(data);
        print('\nKuartil 1 (Q1): ${kuartil[0]}');
        print('Kuartil 2 (Median/Q2): ${kuartil[1]}');
        print('Kuartil 3 (Q3): ${kuartil[2]}');
        break;
      case '8':
        stdout.write('Masukkan persentil yang ingin dihitung (0–100): ');
        double p = double.parse(stdin.readLineSync()!);
        print('Persentil ke-$p: ${hitungPersentil(data, p)}');
        break;
      case '9':
        print('\nTerima kasih telah menggunakan program ini!');
        return;
      default:
        print('\nPilihan tidak valid!');
    }
  }
}

double hitungMean(List<double> data) =>
    data.reduce((a, b) => a + b) / data.length;

double hitungMedian(List<double> data) {
  List<double> sorted = List.from(data)..sort();
  int n = sorted.length;
  return n.isOdd ? sorted[n ~/ 2] : (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2;
}

String hitungModus(List<double> data) {
  Map<double, int> freq = {};
  for (var x in data) {
    freq[x] = (freq[x] ?? 0) + 1;
  }
  int maxFreq = freq.values.reduce(max);
  List<double> modus = freq.entries
      .where((e) => e.value == maxFreq)
      .map((e) => e.key)
      .toList();
  if (maxFreq == 1) return 'Tidak ada modus';
  return modus.join(', ');
}

double hitungVariansi(List<double> data) {
  double mean = hitungMean(data);
  double jumlah = data
      .map((x) => pow(x - mean, 2).toDouble())
      .reduce((a, b) => a + b);
  return jumlah / data.length;
}

double hitungDeviasi(List<double> data) => sqrt(hitungVariansi(data));

double hitungRange(List<double> data) {
  List<double> sorted = List.from(data)..sort();
  return sorted.last - sorted.first;
}

List<double> hitungKuartil(List<double> data) {
  List<double> sorted = List.from(data)..sort();
  int n = sorted.length;
  double q2 = hitungMedian(sorted);

  List<double> lower = sorted.sublist(0, n ~/ 2);
  List<double> upper = n.isOdd
      ? sorted.sublist(n ~/ 2 + 1)
      : sorted.sublist(n ~/ 2);

  double q1 = hitungMedian(lower);
  double q3 = hitungMedian(upper);

  return [q1, q2, q3];
}

double hitungPersentil(List<double> data, double p) {
  if (p < 0 || p > 100) throw ArgumentError('Persentil harus 0–100');
  List<double> sorted = List.from(data)..sort();
  double rank = (p / 100) * (sorted.length - 1);
  int bawah = rank.floor();
  int atas = rank.ceil();
  if (bawah == atas) return sorted[bawah];
  return sorted[bawah] + (rank - bawah) * (sorted[atas] - sorted[bawah]);
}
