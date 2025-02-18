import 'package:storage/storage.dart';
import 'package:widget_repository/widget_repository.dart';

import '../../model/widget_filter.dart';
import '../../repository/widget_repository.dart';


/// create by 张风捷特烈 on 2020-03-03
/// contact me by email 1981462002@qq.com
/// 说明 : Widget数据仓库

class WidgetDbRepository implements WidgetRepository {
  const WidgetDbRepository();

  WidgetDao get widgetDao => AppStorage().flutter<WidgetDao>();

  LikeDao get likeDao => AppStorage().flutter<LikeDao>();

  @override
  Future<List<WidgetModel>> loadLikeWidgets() async {
    // return [];
    List<int> likeIds = await likeDao.likeWidgetIds();
    List<Map<String, dynamic>> data = await widgetDao.queryByIds(likeIds, null);
    List<WidgetPo> widgets = data.map((e) => WidgetPo.fromJson(e)).toList();
    return widgets.map(WidgetModel.fromPo).toList();
  }

  @override
  Future<List<WidgetModel>> searchWidgets(WidgetFilter args) async {
    List<Map<String, dynamic>> data = await widgetDao.search(args);
    List<WidgetPo> widgets = data.map((e) => WidgetPo.fromJson(e)).toList();
    return widgets.map(WidgetModel.fromPo).toList();
  }

  @override
  Future<List<WidgetModel>> loadWidget(List<int> id,String? locale) async {
    List<Map<String, dynamic>> data = await widgetDao.queryByIds(id,locale);
    List<WidgetPo> widgets = data.map((e) => WidgetPo.fromJson(e)).toList();
    if (widgets.isNotEmpty) return widgets.map(WidgetModel.fromPo).toList();
    return [];
  }

  @override
  Future<void> toggleLike(
    int id,
  ) {
    return likeDao.toggleCollect(id);
  }

  @override
  Future<int> collected(int id) async {
    return await likeDao.like(id);
  }

  @override
  Future<int> total(WidgetFilter args) => widgetDao.total(args);

  @override
  Future<WidgetModel?> queryWidgetByName(String? name) async {
    if (name == null) return null;
    Map<String, dynamic>? data = await widgetDao.queryWidgetByName(name);
    if (data != null) {
      return WidgetModel.fromPo(WidgetPo.fromJson(data));
    }
    return null;
  }
}
