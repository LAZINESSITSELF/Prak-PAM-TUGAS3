import 'package:flutter/material.dart';
import 'package:modul_3/models/anime_model.dart';
import 'package:modul_3/presenters/anime_presenter.dart';
import 'package:modul_3/views/detail/anime_detail.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen>
    implements AnimeView {
  late AnimePresenter _presenter;
  bool _isLoading = false;
  List<Anime> _animeList = [];
  String? _errorMessage;
  String _currentEndpoint = 'akatsuki';

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(this);
    _presenter.loadAnimedata(_currentEndpoint);
  }

  void _fetchData(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
      _presenter.loadAnimedata(endpoint);
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showAnimeList(List<Anime> animeList) {
    setState(() {
      _animeList = animeList;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anime List"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => _fetchData('akatsuki'),
                  child: Text("Akatsuki")),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () => _fetchData('kara'), child: Text("Kara"))
            ],
          ),
          Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text("Error : ${_errorMessage}"))
                      : ListView.builder(
                          itemCount: _animeList.length,
                          itemBuilder: (context, index) {
                            final anime = _animeList[index];
                            return ListTile(
                              leading: anime.imageUrl.isNotEmpty
                                  ? Image.network(anime.imageUrl)
                                  : Image.network(
                                      'https://placehold.co/600x400'),
                              title: Text(anime.name),
                              subtitle: Text('${anime.familyCreator}'),
                              onTap: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      id: anime.id,
                                        endpoint: _currentEndpoint),
                                ),
                              );
                              },
                            );
                        },
                      ),
          )
        ],
      ),
    );
  }
}
