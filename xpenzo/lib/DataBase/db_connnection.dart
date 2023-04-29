import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:xpenso/DataBase/data_model.dart';

//********************* Creating DataBase and Table  *******************/

class DBConnections {
  Future<Database> setDB() async {
    var dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, 'myDB');
    var dbCon = await openDatabase(path, version: 1, onCreate: createDB);
    return dbCon;
  }

  Future createDB(Database dbCon, int version) async {
    String sql =
        'create table ledger_t (id INTEGER PRIMARY KEY, amount REAL, notes TEXT, categoryIndex INTEGER, categoryFlag INTEGER, category TEXT, day TEXT,month TEXT,year TEXT,createdT TEXT,attachmentFlag INTEGER,attachmentName TEXT)';
    await dbCon.execute(sql);
  }
}

//*********************** Creating Repository  *************************/

class Repository {
  late DBConnections dbConnections;
  Repository() {
    dbConnections = DBConnections();
  }

  static Database? db;
// Crating DataBase if its not created or return existing DataBase if its alreay there
  Future<Database?> get database async {
    if (db != null) {
      return db;
    } else {
      db = await dbConnections.setDB();
      return db;
    }
  }

  //Insert Data Function
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  //Read Data Function
  readData(table, day, mon, year) async {
    var connection = await database;
    return await connection?.rawQuery(
        'Select * from $table where day = \'${day.toString()}\' and month = \'${mon.toString()}\' and year = \'${year.toString()}\' order by createdT desc');
  }

  dayTotal(table, day, mon, year, flag) async {
    var connection = await database;
    return await connection?.rawQuery(
        'Select sum(amount) as sum from $table where day = \'${day.toString()}\' and month = \'${mon.toString()}\' and year = \'${year.toString()}\' and categoryFlag =\'${flag.toString()}\' ');
  }

  monthTotal(table, mon, year, flag) async {
    var connection = await database;
    return await connection?.rawQuery(
        'Select sum(amount) as sum from $table where month = \'${mon.toString()}\' and year = \'${year.toString()}\' and categoryFlag =\'${flag.toString()}\' ');
  }

  yearTotal(table, year, flag) async {
    var connection = await database;
    return await connection?.rawQuery(
        'Select sum(amount) as sum from $table where year = \'${year.toString()}\' and categoryFlag =\'${flag.toString()}\' ');
  }

  //Update Function
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: "id=?", whereArgs: [data['id']]);
  }

  //Detete Function
  deleteFunction(table, id) async {
    var connection = await database;
    return await connection?.rawDelete('Delete from $table where id = $id');
  }

//Charts Function
  getMonthChartData(table, mon, year, flag) async {
    var connection = await database;
    return await connection?.rawQuery(
        'Select sum(amount) as sum ,categoryIndex as category from $table where month = \'${mon.toString()}\' and year = \'${year.toString()}\' and categoryFlag =\'${flag.toString()}\' group by categoryIndex');
  }

  getYearChartData(table, year, flag) async {
    var connection = await database;
    return await connection?.rawQuery(
        'Select sum(amount) as sum ,categoryIndex as category from $table where  year = \'${year.toString()}\' and categoryFlag =\'${flag.toString()}\' group by categoryIndex');
  }

  //Balance Available

  getBalance(table, flag) async {
    var connection = await database;
    return await connection?.rawQuery(
        'select sum(amount) as sum from $table where categoryFlag =\'${flag.toString()}\'');
  }
}

//************************ Creating Services ************************/

class Services {
  late Repository repo = Repository();
  Services() {
    repo = Repository();
  }

  //Insert Data
  saveData(Ledger insert) async {
    return await repo.insertData('ledger_t', insert.ledgerMap());
  }

  //Read Data
  getData(day, mon, year) async {
    return await repo.readData('ledger_t', day, mon, year);
  }

  getDayTotal(day, mon, year, flag) async {
    return await repo.dayTotal('ledger_t', day, mon, year, flag);
  }

  getMonthTotal(mon, year, flag) async {
    return await repo.monthTotal('ledger_t', mon, year, flag);
  }

  getYearTotal(year, flag) async {
    return await repo.yearTotal('ledger_t', year, flag);
  }

  deleteData(id) async {
    return await repo.deleteFunction('ledger_t', id);
  }
//Total Balance

  getBalance(flag) async {
    return await repo.getBalance('ledger_t', flag);
  }

//************************** For Charts ***********************/
  getMonthChartData(mon, year, flag) async {
    return await repo.getMonthChartData('ledger_t', mon, year, flag);
  }

  getYearChartData(year, flag) async {
    return await repo.getYearChartData('ledger_t', year, flag);
  }

  updateCF(Ledger ledger) async {
    return await repo.updateData('ledger_t', ledger.ledgerMap());
  }
}
