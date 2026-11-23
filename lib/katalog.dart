import 'package:flutter/material.dart';

// Warna utama aplikasi
const Color warnaUtama = Colors.deepPurple;
const Color warnaAksen = Colors.deepOrange;

// Menyimpan nama produk yang difavoritkan (dipakai bersama oleh Grid & Detail)
final ValueNotifier<Set<String>> daftarFavorit = ValueNotifier<Set<String>>({});

// Menambah / menghapus favorit lalu menampilkan SnackBar
void ubahFavorit(BuildContext context, Map<String, String> item) {
  final nama = item['nama']!;
  final baru = Set<String>.from(daftarFavorit.value);
  final ditambah = baru.add(nama);
  if (!ditambah) baru.remove(nama);
  daftarFavorit.value = baru;

  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        ditambah ? '$nama ditambahkan ke Favorit' : '$nama dihapus dari Favorit',
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

// Tombol hati (favorit)
class TombolFavorit extends StatelessWidget {
  final Map<String, String> item;
  const TombolFavorit({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: daftarFavorit,
      builder: (context, favorit, _) {
        final aktif = favorit.contains(item['nama']);
        return IconButton(
          tooltip: aktif ? 'Hapus dari favorit' : 'Tambah ke favorit',
          icon: Icon(
            aktif ? Icons.favorite : Icons.favorite_border,
            color: aktif ? Colors.red : Colors.grey,
          ),
          onPressed: () => ubahFavorit(context, item),
        );
      },
    );
  }
}

// Baris rating bintang
class BarisRating extends StatelessWidget {
  final String rating;
  final double ukuran;
  const BarisRating({super.key, required this.rating, this.ukuran = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: ukuran + 2),
        const SizedBox(width: 2),
        Text(
          rating,
          style: TextStyle(fontSize: ukuran, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// Gambar produk dari internet, dengan loading dan cadangan jika gagal
Widget gambarProduk(String url, {double? size}) {
  return Image.network(
    url,
    width: size,
    height: size,
    fit: BoxFit.contain,
    loadingBuilder: (context, child, progress) {
      if (progress == null) return child;
      return SizedBox(
        width: size,
        height: size,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    },
    errorBuilder: (context, error, stack) => SizedBox(
      width: size,
      height: size,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    ),
  );
}

// Katalog sekarang StatefulWidget supaya bisa berpindah List <-> Grid
class Katalog extends StatefulWidget {
  const Katalog({super.key});

  static const List<Map<String, String>> items = [
    {
      'nama': 'Tas Ransel Laptop',
      'kategori': 'Tas',
      'harga': 'Rp 350.000',
      'rating': '4.5',
      'gambar': 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png',
      'deskripsi':
          'Tas ransel muat laptop hingga 15 inci, cocok untuk kuliah dan kerja.',
    },
    {
      'nama': 'Kaos Slim Fit Pria',
      'kategori': 'Pakaian',
      'harga': 'Rp 120.000',
      'rating': '4.2',
      'gambar':
          'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_t.png',
      'deskripsi': 'Kaos bahan katun lembut, nyaman dipakai sehari-hari.',
    },
    {
      'nama': 'Jaket Katun Pria',
      'kategori': 'Pakaian',
      'harga': 'Rp 425.000',
      'rating': '4.6',
      'gambar': 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_t.png',
      'deskripsi': 'Jaket hangat untuk musim hujan dan perjalanan jauh.',
    },
    {
      'nama': 'Kemeja Casual',
      'kategori': 'Pakaian',
      'harga': 'Rp 180.000',
      'rating': '4.1',
      'gambar': 'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_t.png',
      'deskripsi': 'Kemeja casual slim fit, cocok untuk acara santai.',
    },
    {
      'nama': 'Gelang Rantai Perak',
      'kategori': 'Aksesoris',
      'harga': 'Rp 275.000',
      'rating': '4.7',
      'gambar':
          'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_t.png',
      'deskripsi': 'Gelang rantai model naga, bahan perak berkualitas.',
    },
    {
      'nama': 'Hardisk Eksternal 2TB',
      'kategori': 'Elektronik',
      'harga': 'Rp 950.000',
      'rating': '4.4',
      'gambar': 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_t.png',
      'deskripsi': 'Penyimpanan portable USB 3.0, cepat dan ringkas.',
    },
    {
      'nama': 'Monitor Lengkung 24 Inci',
      'kategori': 'Elektronik',
      'harga': 'Rp 1.800.000',
      'rating': '4.8',
      'gambar': 'https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_t.png',
      'deskripsi':
          'Monitor lengkung Full HD dengan warna tajam untuk kerja dan game.',
    },
    {
      'nama': 'SSD Internal 1TB',
      'kategori': 'Elektronik',
      'harga': 'Rp 1.250.000',
      'rating': '4.6',
      'gambar': 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_t.png',
      'deskripsi':
          'SSD SATA 1TB, membuat laptop lebih cepat menyala dan membuka aplikasi.',
    },
    {
      'nama': 'Cincin Emas Wanita',
      'kategori': 'Aksesoris',
      'harga': 'Rp 520.000',
      'rating': '4.3',
      'gambar':
          'https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_t.png',
      'deskripsi':
          'Cincin emas model elegan, cocok untuk acara formal maupun harian.',
    },
  ];

  @override
  State<Katalog> createState() => _KatalogState();
}

class _KatalogState extends State<Katalog> {
  // false = tampil List, true = tampil Grid
  bool tampilGrid = false;

  List<Map<String, String>> get items => Katalog.items;

  void _bukaDetail(Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailProduk(produk: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          tampilGrid ? 'Galeri Produk' : 'Daftar Produk',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: warnaUtama,
        actions: [
          // Tombol untuk berpindah tampilan List <-> Grid
          IconButton(
            tooltip: tampilGrid ? 'Tampilkan List' : 'Tampilkan Grid',
            icon: Icon(
              tampilGrid ? Icons.view_list : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: () => setState(() => tampilGrid = !tampilGrid),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: tampilGrid
            ? KeyedSubtree(key: const ValueKey('grid'), child: _buildGrid())
            : KeyedSubtree(key: const ValueKey('list'), child: _buildList()),
      ),
    );
  }

  // ---------- Tampilan LIST ----------
  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () => _bukaDetail(item),
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: gambarProduk(item['gambar']!, size: 60),
            ),
            title: Text(
              item['nama']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['deskripsi']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item['harga']!,
                      style: const TextStyle(
                        color: warnaAksen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    BarisRating(rating: item['rating']!),
                  ],
                ),
              ],
            ),
            trailing: Chip(
              label: Text(
                item['kategori']!,
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: warnaUtama.withOpacity(0.1),
              padding: EdgeInsets.zero,
            ),
          ),
        );
      },
    );
  }

  // ---------- Tampilan GRID (responsif) ----------
  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ponsel = 2 kolom, layar lebar (>= 600 px) = 3 kolom
        final jumlahKolom = constraints.maxWidth >= 600 ? 3 : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: jumlahKolom,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: EdgeInsets.zero,
              color: Colors.white,
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _bukaDetail(item),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: gambarProduk(item['gambar']!),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: TombolFavorit(item: item),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nama']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          BarisRating(rating: item['rating']!),
                          const SizedBox(height: 2),
                          Text(
                            item['harga']!,
                            style: const TextStyle(
                              color: warnaAksen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Halaman detail produk (menerima data dari halaman Katalog)
class DetailProduk extends StatelessWidget {
  final Map<String, String> produk;

  const DetailProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          produk['nama']!,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: warnaUtama,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [TombolFavorit(item: produk)],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            height: 300,
            padding: const EdgeInsets.all(24),
            child: gambarProduk(produk['gambar']!),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(produk['kategori']!),
                  backgroundColor: warnaUtama.withOpacity(0.1),
                ),
                const SizedBox(height: 8),
                Text(
                  produk['nama']!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  produk['harga']!,
                  style: const TextStyle(
                    fontSize: 20,
                    color: warnaAksen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                BarisRating(rating: produk['rating']!, ukuran: 16),
                const Divider(height: 32),
                const Text(
                  'Deskripsi Produk',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  produk['deskripsi']!,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: warnaAksen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Tambah ke Keranjang'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${produk['nama']} ditambahkan ke keranjang'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}