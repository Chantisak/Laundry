import 'package:flutter/material.dart';
import 'package:laundry/src/services/network_service.dart';

class TopUp extends StatefulWidget {
  const TopUp({super.key});

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up'),
      ),
      body: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _header(),
          const SizedBox(
            height: 20,
          ),
          _topupItem('จำนวน 10 บาท', onTap: () {
            topup(10);
          }),
          _topupItem('จำนวน 20 บาท', onTap: () {
            topup(20);
          }),
          _topupItem('จำนวน 30 บาท', onTap: () {
            topup(30);
          }),
          _topupItem('จำนวน 100 บาท', onTap: () {
            topup(100);
          }),
          _topupItem('จำนวน 200 บาท', onTap: () {
            topup(200);
          }),
        ]),
      ),
    );
  }

  Future<void> topup(
    int price,
  ) async {
    await NetworkService().topup(price).then((value) {
      if (value.result == "ok") {
        SnackBar snackBar = SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('เติมเงินสำเร็จ'),
              Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            ],
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(
          content: Text('เติมเงินไม่สำเร็จ โปรดลองอีกครั้ง'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  _topupItem(String title, {Function()? onTap}) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: onTap,
          leading: const Icon(Icons.paid),
          iconColor: const Color.fromARGB(255, 0, 0, 0),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      );
  _header() => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              height: 200,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 2, 93, 167),
                    Color.fromARGB(255, 0, 3, 84)
                  ]),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
              child: Padding(
                padding: const EdgeInsets.only(top: 45),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'เติมเงิน',
                              style:
                                  TextStyle(fontSize: 40, color: Colors.yellow),
                            ),
                            Text(
                              '"บริการเติมเงิน ง่าย สะดวก"',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 15),
                      child: Image.asset(
                        'assets/images/coin.png',
                        height: 100,
                      ),
                    )
                  ],
                ),
              )),
        ],
      );
}
