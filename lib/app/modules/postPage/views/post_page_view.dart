import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/post_page_controller.dart';

class PostPageView extends GetView<PostPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PostPageView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PostPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
