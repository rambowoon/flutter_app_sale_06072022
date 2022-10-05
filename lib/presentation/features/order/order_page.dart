import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sale_06072022/common/bases/base_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/model/order.dart';
import '../../../data/model/product.dart';
import '../../../data/repositories/product_repository.dart';
import 'order_bloc.dart';
import 'order_event.dart';
class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("Đơn hàng đã đặt"),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10, top: 10),
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, VariableConstant.HOME_ROUTE, (Route<dynamic> route) => false);
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
        ProxyProvider<ProductRepository, OrderBloc>(
          update: (context, repository, bloc) {
            bloc?.updateOrderRepository(repository);
            return bloc ?? OrderBloc()
              ..updateOrderRepository(repository);
          },
        ),
      ],
      child: BuildContainerOrder(),
    );
  }
}

class BuildContainerOrder extends StatefulWidget {
  const BuildContainerOrder({Key? key}) : super(key: key);

  @override
  State<BuildContainerOrder> createState() => _BuildContainerOrderState();
}

class _BuildContainerOrderState extends State<BuildContainerOrder> {
  List<Order>? _orderModel;
  late OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _orderBloc = context.read<OrderBloc>();
    _orderBloc.eventSink.add(GetListOrderEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context, _orderModel);
        return true;
      },
      child: SafeArea(
          child: Container(
            child: Stack(
              children: [
                StreamBuilder<List<Order>>(
                    initialData: null,
                    stream: _orderBloc.listOrderController.stream,
                    builder: (context, snapshot) {
                      print(snapshot);
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                              'You don\'t have any orders yet.',
                              style:
                              TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            )
                        );
                      }
                      if (snapshot.hasData) {
                        _orderModel = snapshot.data;
                        if (snapshot.data?.length == 0) {
                          return const Center(
                              child: Text(
                                'You don\'t have any orders yet.',
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
                                    itemCount: snapshot.data?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      return _buildItemOrder(
                                          snapshot.data?[index]);
                                    }
                                )
                            ),
                          ],
                        );
                      }
                      return Container();
                    }
                ),
                LoadingWidget(
                  bloc: _orderBloc,
                  child: Container(),
                )
              ],
            ),

          )
      ),
    );
  }

  Widget _buildItemOrder(Order? order) {
    List<Product>? products = order?.products;
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, VariableConstant.ORDER_HISTORY_DETAIL_ROUTE, arguments: order);
          },
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
                    child: Image.network(
                        ApiConstant.BASE_URL + (products?.first.img).toString(),
                        width: 100,
                        height: 80,
                        fit: BoxFit.fill),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Text(DateFormat('dd-MM-yyyy, hh:mm a')
                              .format(DateTime.parse(order!.dateCreated))
                              .toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Text( '( ' + order.products.length.toString() + " món )",
                            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                                "Tổng tiền : ",
                                style: TextStyle(fontSize: 12)),
                            Text( NumberFormat("#,###", "en_US")
                                .format(order.price) +
                                " đ",
                                style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold)),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
