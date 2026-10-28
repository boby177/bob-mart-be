// =====================================================================
// bobMart — seed awal Neo4j
// Jalankan BAGIAN 1 dulu (constraint), baru BAGIAN 2 (data) secara terpisah.
// Semua pakai MERGE berdasarkan id, jadi aman dijalankan ulang (tidak dobel).
// =====================================================================


// ---------------------------------------------------------------------
// BAGIAN 1 — CONSTRAINT (unique + otomatis bikin index)
// ---------------------------------------------------------------------
CREATE CONSTRAINT customer_id IF NOT EXISTS FOR (n:Customer) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT customer_email IF NOT EXISTS FOR (n:Customer) REQUIRE n.email IS UNIQUE;
CREATE CONSTRAINT seller_id IF NOT EXISTS FOR (n:Seller) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT seller_email IF NOT EXISTS FOR (n:Seller) REQUIRE n.email IS UNIQUE;
CREATE CONSTRAINT product_id IF NOT EXISTS FOR (n:Product) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT category_id IF NOT EXISTS FOR (n:Category) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT category_slug IF NOT EXISTS FOR (n:Category) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT order_id IF NOT EXISTS FOR (n:Order) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT wallet_id IF NOT EXISTS FOR (n:Wallet) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT wallet_tx_id IF NOT EXISTS FOR (n:WalletTransaction) REQUIRE n.id IS UNIQUE;


// ---------------------------------------------------------------------
// BAGIAN 2 — DATA (satu statement, jalankan sekaligus)
// Pola id per label biar gampang dikenali:
//   1111... Customer | 2222... Seller | 3333... Product | 4444... Category
//   5555... Order    | 6666... Wallet | 7777... WalletTransaction
// ---------------------------------------------------------------------

// --- Customer ---
MERGE (c1:Customer {id: '11111111-1111-4111-8111-000000000001'})
  SET c1.name = 'Andi Pratama', c1.email = 'andi@example.com',
      c1.passwordHash = 'SEED_NOT_A_REAL_HASH', c1.city = 'Jakarta',
      c1.createdAt = datetime('2026-10-01T09:00:00+07:00')
MERGE (c2:Customer {id: '11111111-1111-4111-8111-000000000002'})
  SET c2.name = 'Siti Rahma', c2.email = 'siti@example.com',
      c2.passwordHash = 'SEED_NOT_A_REAL_HASH', c2.city = 'Bandung',
      c2.createdAt = datetime('2026-10-02T10:00:00+07:00')

// --- Seller ---
MERGE (s1:Seller {id: '22222222-2222-4222-8222-000000000001'})
  SET s1.storeName = 'Jaya Elektronik', s1.email = 'jaya@example.com',
      s1.passwordHash = 'SEED_NOT_A_REAL_HASH', s1.city = 'Surabaya',
      s1.createdAt = datetime('2026-09-20T08:00:00+07:00')
MERGE (s2:Seller {id: '22222222-2222-4222-8222-000000000002'})
  SET s2.storeName = 'Gadget Corner', s2.email = 'gadget@example.com',
      s2.passwordHash = 'SEED_NOT_A_REAL_HASH', s2.city = 'Bekasi',
      s2.createdAt = datetime('2026-09-22T08:00:00+07:00')

// --- Category (Handphone adalah sub-kategori Elektronik) ---
MERGE (cat1:Category {id: '44444444-4444-4444-8444-000000000001'})
  SET cat1.name = 'Elektronik', cat1.slug = 'elektronik'
MERGE (cat2:Category {id: '44444444-4444-4444-8444-000000000002'})
  SET cat2.name = 'Handphone', cat2.slug = 'handphone'
MERGE (cat2)-[:SUBCATEGORY_OF]->(cat1)

// --- Product (stok = sisa setelah order di bawah) ---
MERGE (p1:Product {id: '33333333-3333-4333-8333-000000000001'})
  SET p1.name = 'HP Nova 5', p1.description = 'Smartphone 6.5 inci, RAM 8GB',
      p1.price = 2500000, p1.stock = 9,
      p1.createdAt = datetime('2026-09-25T08:00:00+07:00')
MERGE (p2:Product {id: '33333333-3333-4333-8333-000000000002'})
  SET p2.name = 'TWS Earbuds Pro', p2.description = 'Earbuds wireless, noise cancelling',
      p2.price = 350000, p2.stock = 23,
      p2.createdAt = datetime('2026-09-26T08:00:00+07:00')
MERGE (s1)-[:SELLS]->(p1)
MERGE (s2)-[:SELLS]->(p2)
MERGE (p1)-[:IN_CATEGORY]->(cat2)
MERGE (p2)-[:IN_CATEGORY]->(cat1)

// --- Wallet (saldo = hasil akhir dari WalletTransaction di bawah) ---
MERGE (w1:Wallet {id: '66666666-6666-4666-8666-000000000001'})
  SET w1.balance = 500000, w1.updatedAt = datetime('2026-10-05T14:00:00+07:00')
MERGE (w2:Wallet {id: '66666666-6666-4666-8666-000000000002'})
  SET w2.balance = 300000, w2.updatedAt = datetime('2026-10-06T15:00:00+07:00')
MERGE (w3:Wallet {id: '66666666-6666-4666-8666-000000000003'})
  SET w3.balance = 2500000, w3.updatedAt = datetime('2026-10-05T14:00:00+07:00')
MERGE (w4:Wallet {id: '66666666-6666-4666-8666-000000000004'})
  SET w4.balance = 700000, w4.updatedAt = datetime('2026-10-06T15:00:00+07:00')
MERGE (c1)-[:HAS_WALLET]->(w1)
MERGE (c2)-[:HAS_WALLET]->(w2)
MERGE (s1)-[:HAS_WALLET]->(w3)
MERGE (s2)-[:HAS_WALLET]->(w4)

// --- Order ---
MERGE (o1:Order {id: '55555555-5555-4555-8555-000000000001'})
  SET o1.status = 'PAID', o1.totalAmount = 2500000,
      o1.createdAt = datetime('2026-10-05T14:00:00+07:00')
MERGE (o2:Order {id: '55555555-5555-4555-8555-000000000002'})
  SET o2.status = 'PAID', o2.totalAmount = 700000,
      o2.createdAt = datetime('2026-10-06T15:00:00+07:00')
MERGE (c1)-[:PLACED]->(o1)
MERGE (c2)-[:PLACED]->(o2)
MERGE (o1)-[oi1:CONTAINS]->(p1)
  SET oi1.qty = 1, oi1.unitPrice = 2500000
MERGE (o2)-[oi2:CONTAINS]->(p2)
  SET oi2.qty = 2, oi2.unitPrice = 350000

// --- WalletTransaction (riwayat saldo / ledger) ---
// Andi: top up 3jt -> bayar order 1 (2,5jt) -> sisa 500rb
MERGE (t1:WalletTransaction {id: '77777777-7777-4777-8777-000000000001'})
  SET t1.type = 'TOPUP', t1.amount = 3000000, t1.balanceAfter = 3000000,
      t1.createdAt = datetime('2026-10-04T10:00:00+07:00')
MERGE (t2:WalletTransaction {id: '77777777-7777-4777-8777-000000000002'})
  SET t2.type = 'PAYMENT', t2.amount = 2500000, t2.balanceAfter = 500000,
      t2.createdAt = datetime('2026-10-05T14:00:00+07:00')
// Siti: top up 1jt -> bayar order 2 (700rb) -> sisa 300rb
MERGE (t3:WalletTransaction {id: '77777777-7777-4777-8777-000000000003'})
  SET t3.type = 'TOPUP', t3.amount = 1000000, t3.balanceAfter = 1000000,
      t3.createdAt = datetime('2026-10-06T09:00:00+07:00')
MERGE (t4:WalletTransaction {id: '77777777-7777-4777-8777-000000000004'})
  SET t4.type = 'PAYMENT', t4.amount = 700000, t4.balanceAfter = 300000,
      t4.createdAt = datetime('2026-10-06T15:00:00+07:00')
// Seller menerima uang dari order
MERGE (t5:WalletTransaction {id: '77777777-7777-4777-8777-000000000005'})
  SET t5.type = 'INCOME', t5.amount = 2500000, t5.balanceAfter = 2500000,
      t5.createdAt = datetime('2026-10-05T14:00:00+07:00')
MERGE (t6:WalletTransaction {id: '77777777-7777-4777-8777-000000000006'})
  SET t6.type = 'INCOME', t6.amount = 700000, t6.balanceAfter = 700000,
      t6.createdAt = datetime('2026-10-06T15:00:00+07:00')

MERGE (w1)-[:HAS_TRANSACTION]->(t1)
MERGE (w1)-[:HAS_TRANSACTION]->(t2)
MERGE (w2)-[:HAS_TRANSACTION]->(t3)
MERGE (w2)-[:HAS_TRANSACTION]->(t4)
MERGE (w3)-[:HAS_TRANSACTION]->(t5)
MERGE (w4)-[:HAS_TRANSACTION]->(t6)
MERGE (t2)-[:FOR_ORDER]->(o1)
MERGE (t5)-[:FOR_ORDER]->(o1)
MERGE (t4)-[:FOR_ORDER]->(o2)
MERGE (t6)-[:FOR_ORDER]->(o2);


// ---------------------------------------------------------------------
// CEK HASIL (jalankan di tab baru)
// ---------------------------------------------------------------------
// MATCH (c:Customer)-[r1]->(x)
// OPTIONAL MATCH (x)-[r2]->(y)
// RETURN c, r1, x, r2, y;
