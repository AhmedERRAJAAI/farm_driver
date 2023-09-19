import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/side_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge_widget.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = 'home/';
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

openCart(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(CartScreen.routeName);
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _onlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchProducts()
          .then((_) {
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
        title: const Text("My shop"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => BadgeWidget(
              count: cart.itemCount,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  openCart(context);
                },
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: (selectedVal) {
              setState(() {
                if (selectedVal == 0) {
                  _onlyFavorites = true;
                } else if (selectedVal == 1) {
                  _onlyFavorites = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Favorites products"),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text("All products"),
              )
            ],
          ),
        ],
      ),
      drawer: const SideDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  backgroundColor: Color.fromARGB(135, 54, 181, 244)),
            )
          : ProductsGrid(_onlyFavorites),
    );
  }
}
