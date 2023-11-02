String queryInitDb = '''
 $initQueryItem
 $initQueryDefaultItem
 $initQueryItemVarian
 $initQueryDefaultItemVarian
 $initQueryDefaultItemVarianKacangTanah
 $initQueryKategori
 $initQueryDefaultKategori
 $initQueryPenjualan
 $initQueryPembelian 
''';

const String initQueryItem = '''
 CREATE TABLE item
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(150) NOT NULL
    );
''';

const String initQueryDefaultItem = '''
  INSERT INTO item(id, name) values
    (1, "Kacang Mete"),
    (2, "Kacang Tanah");
''';

const String initQueryItemVarian = '''
 CREATE TABLE item_varian
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      varian VARCHAR(150) NOT NULL,
      harga BIGINT NOT NULL,
      item_id INT NOT NULL,
      FOREIGN KEY (item_id) REFERENCES item(id)
    );
''';

const initQueryDefaultItemVarian = '''
  INSERT INTO item_varian (varian, harga, item_id) VALUES
    ('1/4 kg', 20000, 1),
    ('1/2 kg', 30000, 1),
    ('1 kg', 40000, 1);
''';

const initQueryDefaultItemVarianKacangTanah = '''
  INSERT INTO item_varian (varian, harga, item_id) VALUES
    ('1/2 kg', 15000, 2),
    ('1 kg', 25000, 2);
''';

const String initQueryKategori = '''
  CREATE TABLE kategori
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(150) NOT NULL
    );
''';

const String initQueryDefaultKategori = '''
  INSERT INTO kategori(name) VALUES
    ('Pembelian Kacang Mete Glondongan'),
    ('Minyak Goreng'),
    ('Plastik Kemasan'),
    ('Bumbu'),
    ('Transport');
''';

const String initQueryPenjualan = '''
 CREATE TABLE pembelian
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      harga BIGINT NOT NULL,
      keterangan VARCHAR(150) NOT NULL,
      tgl date NOT NULL,
      kategori_id INT NOT NULL,
      FOREIGN KEY (kategori_id) REFERENCES kategori(id)
    );

''';

const String initQueryPembelian = '''
  CREATE TABLE penjualan
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tgl date NOT NULL,
      qty INT NOT NULL,
      stored_price BIGINT NOT NULL,
      item_varian_id INT NOT NULL,
      FOREIGN KEY (item_varian_id) REFERENCES item_varian(id)
    );
''';
