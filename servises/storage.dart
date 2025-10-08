import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSharedPreferences implements SharedPreferences {
  static void initiatePreferences() {
    SharedPreferences.setPrefix("billfold_");
  }

  final SharedPreferences _storage;
  final String _prefix;
  LocalSharedPreferences._(String prefix, SharedPreferences storage)
      : this._prefix = prefix,
        this._storage = storage;
  static Future<LocalSharedPreferences> getInstance(
      [String prefix = ""]) async {
    return LocalSharedPreferences._(
        prefix, await SharedPreferences.getInstance());
  }

  @override
  Future<bool> clear() async {
    var futuresremoves =
        this.getKeys().map((element) => this._storage.remove(element));

    List<bool> result = await Future.wait<bool>(futuresremoves);
    bool out = result.any((element) => element);
    return out;
  }

  Future<bool> clearAll() async {
    return _storage.clear();
  }

  @override
  @Deprecated('This method is now a no-op, and should no longer be called.')
  Future<bool> commit() {
    return _storage.commit();
  }

  @override
  bool containsKey(String key) {
    return _storage.containsKey("$_prefix$key");
  }

  @override
  Object? get(String key) {
    return _storage.get("$_prefix$key");
  }

  @override
  bool? getBool(String key) {
    return _storage.getBool("$_prefix$key");
  }

  @override
  double? getDouble(String key) {
    return _storage.getDouble("$_prefix$key");
  }

  @override
  int? getInt(String key) {
    return _storage.getInt("$_prefix$key");
  }

  @override
  Set<String> getKeys() {
    return _storage
        .getKeys()
        .where((element) => element.startsWith(_prefix))
        .toSet();
  }

  @override
  String? getString(String key) {
    return _storage.getString("$_prefix$key");
  }

  @override
  List<String>? getStringList(String key) {
    return _storage.getStringList("$_prefix$key");
  }

  @override
  Future<void> reload() {
    return _storage.reload();
  }

  @override
  Future<bool> remove(String key) async {
    return _storage.remove("$_prefix$key");
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return _storage.setBool("$_prefix$key", value);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    return _storage.setDouble("$_prefix$key", value);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return _storage.setInt("$_prefix$key", value);
  }

  @override
  Future<bool> setString(String key, String value) {
    return _storage.setString("$_prefix$key", value);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) {
    return _storage.setStringList("$_prefix$key", value);
  }
}

class CognitoLocalStorage extends CognitoStorage {
  static final _instance = CognitoLocalStorage.createinstance();

  LocalSharedPreferences? _storage;
  CognitoLocalStorage.createinstance() {
    createOrgetStorage();
  }

  Future<LocalSharedPreferences> createOrgetStorage() async {
    if (
      _storage == null) {
      _storage = await LocalSharedPreferences.getInstance("auth_");
    }
    return _storage!;
  }

  factory CognitoLocalStorage() {
    return _instance;
  }

  @override
  Future<void> clear() async {
    await createOrgetStorage()
      ..clear();
  }

  @override
  Future<dynamic> getItem(String key) async {
    LocalSharedPreferences _instance = await createOrgetStorage();

    return _instance.get(key);
  }

  @override
  Future<bool> removeItem(String key) async {
    LocalSharedPreferences _instance = await createOrgetStorage();
    return _instance.remove(key);
  }

  Future<bool> setItemBy<T>(String key, T value) async {
    return await this.setItem(key, value);
  }

  @override
  Future<bool> setItem(String key, value) async {
    LocalSharedPreferences _instance = await createOrgetStorage();
    if (value is int) {
      return _instance.setInt(key, value);
    }
    if (value is bool) {
      return _instance.setBool(key, value);
    }
    if (value is double) {
      return _instance.setDouble(key, value);
    }
    if (value is String) {
      return _instance.setString(key, value);
    }
    if (value is List<String>) {
      return _instance.setStringList(key, value);
    }
    return _instance.setString(key, value.toString());
  }
}

class CommonLocalStorage extends LocalSharedPreferences {
  static CommonLocalStorage? _instance;
  CommonLocalStorage._(storage) : super._("data", storage) {
    //  LocalSharedPreferences.getInstance();
  }

  Future<bool> clearallbystartkey(prefix) async {
    var futuresremoves = this
        .getKeys()
        .where((element) => element.startsWith(prefix))
        .map((element) => this._storage.remove(element));

    List<bool> result = await Future.wait<bool>(futuresremoves);
    bool out = result.any((element) => element);
    return out;
  }

  static Future<CommonLocalStorage> getInstance() async {
    if (_instance == null)
      _instance =
          CommonLocalStorage._(await LocalSharedPreferences.getInstance());

    return _instance!;
  }
}

class TourLocalStorage extends LocalSharedPreferences {
  static TourLocalStorage? _instance;
  TourLocalStorage._(storage) : super._("tour", storage) {
    //  LocalSharedPreferences.getInstance();
  }

  static Future<TourLocalStorage> getInstance() async {
    if (_instance == null)
      _instance =
          TourLocalStorage._(await LocalSharedPreferences.getInstance());

    return _instance!;
  }
}
