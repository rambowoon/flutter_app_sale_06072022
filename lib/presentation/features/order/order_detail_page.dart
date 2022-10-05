import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../data/model/order.dart';
import '../../../data/model/product.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order detail"),
        actions: [
          Container(
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, VariableConstant.HOME_ROUTE, (Route<dynamic> route) => false);
                },
              )
          )
        ],
      ),
      body: BuildContainerOrder(),
    );
  }
}

class BuildContainerOrder extends StatefulWidget {
  const BuildContainerOrder({Key? key}) : super(key: key);

  @override
  State<BuildContainerOrder> createState() => _BuildContainerOrderState();
}

class _BuildContainerOrderState extends State<BuildContainerOrder> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ngày đặt: ' + DateFormat('dd-MM-yyyy, hh:mm a').format(DateTime.parse(order.dateCreated)).toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: order.products.length,
                    itemBuilder: (context, index) {
                      return _buildItemOrder(order.products[index]);
                    }
                )
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng tiền: ',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                      Text(NumberFormat("#,###", "en_US")
                          .format(order.price) +
                          " đ",
                          style: TextStyle(fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemOrder(Product? product) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Card(
        elevation: 2,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, VariableConstant.ORDER_HISTORY_DETAIL_ROUTE);
          },
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    child: Image.network(
                        ApiConstant.BASE_URL + (product?.img).toString(),
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
                          child: Text(product?.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Text(
                                "Số lượng : " + product!.quantity.toString(),
                                style: TextStyle(fontSize: 12)),
                        ),
                        Row(
                          children: [
                            Text(
                                "Price : ",
                                style: TextStyle(fontSize: 12)),
                            Text(NumberFormat("#,###", "en_US")
                                .format(product.price) +
                                " đ",
                                style: TextStyle(fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
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