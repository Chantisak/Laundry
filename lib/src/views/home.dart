import 'package:flutter/material.dart';
import 'package:laundry/src/models/get_laundry.dart';
import 'package:laundry/src/services/local_storage_service.dart';
import 'package:laundry/src/services/network_service.dart';
import '../widgets/main.drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int money = 0;
  @override
  void initState() {
    data();
    super.initState();
  }

  Future<void> data() async {
    var data = await NetworkService().getUser();

    money = int.parse(data.money ?? '0');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                const Icon(Icons.currency_exchange),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text('จำนวนเงิน $money'),
                )
              ],
            ),
          )
        ],
        title: const Text('Laundry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          data();
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text('จำนวนเครื่องซักผ้า',
                    style: TextStyle(fontSize: 25, color: Colors.black)),
              ),
              FutureBuilder<List<GetLaundryModel>>(
                  future: NetworkService().getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      if ((data ?? []).isEmpty) {
                        return const Text('');
                      }
                      return GridView.builder(
                          padding: const EdgeInsets.all(15),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  childAspectRatio: 1 / 1),
                          itemCount: data!.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color.fromARGB(255, 252, 230, 63),
                                    Color.fromARGB(255, 255, 191, 0)
                                  ]),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Image.asset(
                                              'assets/images/washing-machine.png')),
                                      Column(
                                        children: [
                                          Text('เครื่องซักที่ ${index + 1}'),
                                          Text(
                                              data[index].status == '1'
                                                  ? 'จองแล้ว'
                                                  : 'ว่าง',
                                              style:
                                                  const TextStyle(fontSize: 20))
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: data[index].status == '1'
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                    onPressed: money >=
                                            int.parse(data[index].price!)
                                        ? data[index].status == '1'
                                            ? () async {
                                                final token =
                                                    await LocalStorageService()
                                                        .getToken();

                                                if (data[index].userid ==
                                                    token) {
                                                  NetworkService()
                                                      .reserve(
                                                          data[index].id!, 0)
                                                      .then((value) {
                                                    if (value.result == "ok") {
                                                      SnackBar snackBar =
                                                          SnackBar(
                                                        content: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: const [
                                                            Text(
                                                                'ยกเลิกจองสำเร็จ'),
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.green,
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    } else {
                                                      const snackBar = SnackBar(
                                                        content: Text(
                                                            'เกิดข้อผิดพลาด โปรดลองอีกครั้ง'),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                  });
                                                } else {
                                                  SnackBar snackBar = SnackBar(
                                                    content: Text(
                                                        'ไม่สามารถยกเลิกได้ ผู้จองคือ ${data[index].userid}'),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                                setState(() {});
                                              }
                                            : () {
                                                NetworkService()
                                                    .reserve(data[index].id!, 1)
                                                    .then((value) {
                                                  if (value.result == "ok") {
                                                    SnackBar snackBar =
                                                        SnackBar(
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: const [
                                                          Text('จองสำเร็จ'),
                                                          Icon(
                                                            Icons.check_circle,
                                                            color: Colors.green,
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  } else {
                                                    const snackBar = SnackBar(
                                                      content: Text(
                                                          'เกิดข้อผิดพลาด โปรดลองอีกครั้ง'),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  }
                                                  setState(() {});
                                                });
                                              }
                                        : () {
                                            const snackBar = SnackBar(
                                              content: Text(
                                                  'ยอดเงินไม่เพียงพอ กรุณาเติมเงิน'),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                    child: Text(data[index].status == '1'
                                        ? 'ยกเลิก'
                                        : 'จอง'),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                    return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator());
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _header() => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              height: 250,
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
                padding: const EdgeInsets.only(top: 90),
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
                              'ยินดีต้อนรับ',
                              style:
                                  TextStyle(fontSize: 40, color: Colors.yellow),
                            ),
                            Text(
                              '"ซักตรงเวลา สะอาดหมดจด"',
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
                        'assets/images/luandry-logo.png',
                        height: 80,
                      ),
                    )
                  ],
                ),
              )),
          ss(),
        ],
      );

  ss() => GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(right: 15, left: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 157, 255, 0),
              Color.fromARGB(255, 0, 255, 26)
            ]),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('QR CODE ไลน์กลุ่ม "แจ้งเตือนเมื่อมีการจอง"',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15)),
              const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.grey,
              )
            ],
          ),
        ),
      );
}
