import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:http/http.dart' as http;

const urlNews = 'https://newsapi.org/v2';
const apiKey = '814218bb972940a5a93a2c3469a8e036';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business';
  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyball, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];
  bool _loading = true;

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    getTopHeadlines();
    for (var element in categories) {
      categoryArticles[element.name] = [];
    }
    getTopHeadlinesByCategory(_selectedCategory);
  }

  bool get loading => _loading;

  getTopHeadlines() async {
    final url = Uri.parse('$urlNews/top-headlines?country=us&apiKey=$apiKey');
    final response = await http.get(url);
    final newsResponse = newsResponseFromJson(response.body);
    headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  String get selectedCategory => _selectedCategory;

  set selectedCategory(String valor) {
    _selectedCategory = valor;
    _loading = true;
    getTopHeadlinesByCategory(valor);
    notifyListeners();
  }

  get getArticulosCategoriaSeleccionada => categoryArticles[selectedCategory];

  getTopHeadlinesByCategory(String cateogry) async {
    if (categoryArticles[cateogry]!.isNotEmpty) {
      _loading = false;
      notifyListeners();
      return categoryArticles[cateogry];
    }
    final url = Uri.parse(
        '$urlNews/top-headlines?country=us&apiKey=$apiKey&category=$cateogry');
    final response = await http.get(url);
    final newsResponse = newsResponseFromJson(response.body);
    categoryArticles[cateogry]?.addAll(newsResponse.articles);
    _loading = false;
    notifyListeners();
  }
}
