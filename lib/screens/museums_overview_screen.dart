import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/providers/museums.dart';
import 'package:tour_guide_rental/widgets/app_drawer.dart';
import '../widgets/museums_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class MuseumsOverviewScreen extends StatefulWidget {
  @override
  _MuseumsOverviewScreenState createState() => _MuseumsOverviewScreenState();
  static const routeName = '/museum';
}

class _MuseumsOverviewScreenState extends State<MuseumsOverviewScreen> {
  var _showonlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Museums>(context).fetchAndSetProducts();
  }

  @override
  void initState() {
    // Provider.of<Museums>(context).fetchAndSetProducts(); Not Work
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Museums>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Museums>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Wisatawan'),
        actions: <Widget>[
          // PopupMenuButton(
          //   onSelected: (FilterOptions selectedValue) {
          //     setState(() {
          //       if (selectedValue == FilterOptions.Favorites) {
          //         _showonlyFavorites = true;
          //       } else {
          //         _showonlyFavorites = false;
          //       }
          //     });
          //   },
          //   icon: Icon(
          //     Icons.more_vert,
          //   ),
          //   itemBuilder: (_) => [
          //     PopupMenuItem(
          //       child: Text('Only Favorite'),
          //       value: FilterOptions.Favorites,
          //     ),
          //     PopupMenuItem(
          //       child: Text('Show All'),
          //       value: FilterOptions.All,
          //     ),
          //   ],
          // ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : MuseumsGrid(_showonlyFavorites),
      ),
    );
  }
}
