import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_main_info_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_main_screen_cast_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_model.dart';
import 'package:provider/provider.dart';

class SerialDetailsWidget extends StatefulWidget {
  const SerialDetailsWidget({Key? key}) : super(key: key);

  @override
  State<SerialDetailsWidget> createState() => _SerialDetailsWidgetState();
}

class _SerialDetailsWidgetState extends State<SerialDetailsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(
        () => context.read<SerialDetailsModel>().setupLocale(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title =
        context.select((SerialDetailsModel model) => model.data.title);
    return Text(title);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((SerialDetailsModel model) => model.data.isLoading);
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        SerialDetailsMainInfoWidget(),
        SerialDetailsMainScreenCastWidget(),
      ],
    );
  }
}
