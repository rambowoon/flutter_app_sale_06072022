import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_widget.dart';
import 'package:flutter_app_sale_06072022/data/model/product.dart';
import 'package:flutter_app_sale_06072022/data/repositories/product_repository.dart';
import 'package:flutter_app_sale_06072022/presentation/features/product/product_bloc.dart';
import 'package:flutter_app_sale_06072022/presentation/features/product/product_event.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/constants/api_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../data/datasources/local/cache/app_cache.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/model/cart.dart';
class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("Chi tiết sản phẩm"),
        actions: [
          Consumer<ProductBloc>(
            builder: (context, bloc, child){
              return StreamBuilder<Cart>(
                  initialData: null,
                  stream: bloc.cartController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError || snapshot.data == null || snapshot.data?.products.isEmpty == true) {
                      return Container();
                    }
                    int count = snapshot.data?.products.length ?? 0;
                    return Container(
                      margin: EdgeInsets.only(right: 10, top: 10),
                      child: Badge(
                          badgeContent: Text(count.toString(), style: const TextStyle(color: Colors.white),),
                          child: IconButton(
                            icon: Icon(Icons.shopping_cart_outlined),
                            onPressed: () {
                              Navigator.pushNamed(context, VariableConstant.CART_ROUTE).then((cartUpdate){
                                if(cartUpdate != null){
                                  bloc.cartController.sink.add(cartUpdate as Cart);
                                }
                              });
                            },
                          )
                      ),
                    );
                  }
              );
            },
          )
        ],
      ),
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, ProductRepository>(
          update: (context, request, repository) {
            repository?.updateRequest(request);
            return repository ?? ProductRepository()
              ..updateRequest(request);
          },
        ),
        ProxyProvider<ProductRepository, ProductBloc>(
          update: (context, repository, bloc) {
            bloc?.updateProductRepository(repository);
            return bloc ?? ProductBloc()
              ..updateProductRepository(repository);
          },
        ),
      ],
      child: ProductContainer(),
    );
  }
}

class ProductContainer extends StatefulWidget {
  const ProductContainer({Key? key}) : super(key: key);

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  Product? product;
  late ProductBloc _productBloc;
  String selectedImage = "";
  String image = "";

  @override
  void initState() {
    super.initState();
    _productBloc = context.read<ProductBloc>();
    _productBloc.eventSink.add(GetCartEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var dataReceive = ModalRoute.of(context)?.settings.arguments as Product;
    product = dataReceive;
    selectedImage = image = ApiConstant.BASE_URL + product!.img;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(
              height: getProportionateScreenWidth(250,context),
              child: AspectRatio(
                aspectRatio: 1,
                child: Hero(
                  tag: product!.id,
                  child: Image.network(selectedImage),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSmallProductPreview(image),
                ...List.generate(product!.gallery.length,
                        (index) => buildSmallProductPreview(ApiConstant.BASE_URL + product!.gallery[index])),
              ],
            )
          ],
        ),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20, context)),
                    child: Text(
                      product!.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20, context),
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        Text(
                            "Giá : ",
                            style: const TextStyle(fontSize: 16, color: Colors.black)
                        ),
                        Text(
                            "${NumberFormat("#,###", "en_US")
                                .format(product!.price)} đ",
                            style: const TextStyle(fontSize: 16, color: Colors.red)
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20, context),
                      vertical: 5,
                    ),
                    child: Text(
                      product!.address,
                      maxLines: 4,
                    ),
                  )
                ],
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: getProportionateScreenWidth(40, context),
                    top: getProportionateScreenWidth(15, context),
                  ),
                  child: DefaultButton(
                    text: "Thêm vào giỏ",
                    press: () {
                      _productBloc.eventSink.add(AddToCartEvent(id: product!.id));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        LoadingWidget(
          bloc: _productBloc,
          child: Container(),
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(String url) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = url;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(5),
        height: getProportionateScreenHeight(60, context),
        width: getProportionateScreenWidth(60, context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Color(0xFFFF7643).withOpacity(selectedImage == url ? 1 : 0)),
        ),
        child: Image.network(url),
      ),
    );
  }

}

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenWidth(20, context)),
      padding: EdgeInsets.only(top: getProportionateScreenWidth(20, context)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56, context),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          primary: Colors.white,
          backgroundColor: Color(0xFFFF7643),
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18, context),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

double getProportionateScreenHeight(double inputHeight, BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth, BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

