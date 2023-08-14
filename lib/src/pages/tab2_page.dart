import 'package:flutter/material.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/services/news_service.dart';
import 'package:news_app/src/theme/tema.dart';
import 'package:provider/provider.dart';

import '../widgets/lista_noticias.dart';

class Tab2Page extends StatelessWidget {
  const Tab2Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          const _ListaCategorias(),
          if (!newsService.loading)
            Expanded(
              child: ListaNoticias(
                  noticias: newsService.getArticulosCategoriaSeleccionada),
            ),
          if (newsService.loading)
            Expanded(
                child: Center(
              child: CircularProgressIndicator(),
            ))
        ]),
      ),
    );
  }
}

class _ListaCategorias extends StatelessWidget {
  const _ListaCategorias();

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<NewsService>(context).categories;
    return Container(
      width: double.infinity,
      height: 80,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            final cNmae = categories[index].name;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(children: [
                _CategoryButton(categoria: categories[index]),
                const SizedBox(height: 5),
                Text('${cNmae[0].toUpperCase()}${cNmae.substring(1)}')
              ]),
            );
          }),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final Category categoria;

  const _CategoryButton({required this.categoria});

  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context);
    return GestureDetector(
      onTap: () {
        final newsService = Provider.of<NewsService>(context, listen: false);
        newsService.selectedCategory = categoria.name;
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (newsService.selectedCategory == categoria.name)
                ? miTmea.hintColor
                : Colors.white),
        child: Icon(
          categoria.icon,
          color: Colors.black54,
        ),
      ),
    );
  }
}
