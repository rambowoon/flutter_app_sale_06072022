import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_widget.dart';
import 'package:flutter_app_sale_06072022/data/model/product.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/model/cart.dart';
import '../../../data/repositories/product_repository.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';
class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("My Shopping Cart"),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10, top: 10),
              child: IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  Navigator.pushNamed(context, VariableConstant.ORDER_HISTORY_ROUTE);
                },
              )
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
        ProxyProvider<ProductRepository, CartBloc>(
          update: (context, repository, bloc) {
            bloc?.updateProductRepository(repository);
            return bloc ?? CartBloc()
              ..updateProductRepository(repository);
          },
        ),
      ],
      child: CartContainer(),
    );
  }
}

class CartContainer extends StatefulWidget {
  const CartContainer({Key? key}) : super(key: key);

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  Cart? _cartModel;
  late CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = context.read<CartBloc>();
    _cartBloc.eventSink.add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context, _cartModel);
        return true;
      },
      child: SafeArea(
          child: Container(
            child: Stack(
              children: [
                StreamBuilder<Cart>(
                    initialData: null,
                    stream: _cartBloc.cartController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                              'Your Cart is Empty',
                              style:
                              TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            )
                        );
                      }
                      if (snapshot.hasData) {
                        _cartModel = snapshot.data;
                        if (snapshot.data!.products.isEmpty) {
                          return const Center(
                              child: Text(
                                'Your Cart is Empty',
                                style:
                                TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18.0),
                              )
                          );
                        }
                        return Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data?.products?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      return _buildItemCart(
                                          snapshot.data?.products?[index]);
                                    }
                                )
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.all(Radius
                                        .circular(5))),
                                child: Text(
                                    "Tổng tiền : " +
                                        NumberFormat("#,###", "en_US")
                                            .format(_cartModel?.price) +
                                        " đ",
                                    style: TextStyle(fontSize: 25,
                                        color: Colors.white))),
                            Container(
                                padding: EdgeInsets.all(20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_cartModel != null) {
                                      String? cartId = _cartModel!.id;
                                      _cartBloc.eventSink.add(
                                          CartConformEvent(idCart: cartId));
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          Colors.deepOrange)),
                                  child: Text("Đặt hàng",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25)),
                                )),
                          ],
                        );
                      }
                      return Container();
                    }
                ),
                LoadingWidget(
                  bloc: _cartBloc,
                  child: Container(),
                )
              ],
            ),

          )
      ),
    );
  }

  Widget _buildItemCart(Product? product) {
    return Container(
      height: 135,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                      ApiConstant.BASE_URL + (product?.img).toString(),
                      width: 140,
                      height: 120,
                      fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text((product?.name).toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text(
                          "Giá : " +
                              NumberFormat("#,###", "en_US")
                                  .format(product?.price) +
                              " đ",
                          style: TextStyle(fontSize: 12)),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if(product != null && _cartModel != null) {
                                String? cartId = _cartModel!.id;
                                if(cartId.isNotEmpty) {
                                  _cartBloc.eventSink.add(UpdateCartEvent(
                                      idCart: cartId,
                                      idProduct: product.id,
                                      quantity: product.quantity - 1));
                                }
                              }
                            },
                            child: Text("-"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text((product?.quantity).toString(),
                                style: TextStyle(fontSize: 16)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if(product != null && _cartModel != null) {
                                String? cartId = _cartModel!.id;
                                if(cartId.isNotEmpty) {
                                  _cartBloc.eventSink.add(UpdateCartEvent(
                                      idCart: cartId,
                                      idProduct: product.id,
                                      quantity: product.quantity + 1));
                                }
                              }
                            },
                            child: Text("+"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}