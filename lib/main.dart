import 'package:flutter/material.dart';
import 'katalog.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katalog Produk',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: warnaUtama),
      ),
      home: const Katalog(),
    ),
  );
}