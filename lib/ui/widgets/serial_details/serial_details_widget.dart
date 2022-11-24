import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/library/default_widgets/inherited/notifier_provider.dart';
import 'package:flutter_themoviedb/ui/widgets/app/my_app_model.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_main_info_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_main_screen_cast_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_model.dart';

class SerialDetailsWidget extends StatefulWidget {
  const SerialDetailsWidget({Key? key}) : super(key: key);

  @override
  State<SerialDetailsWidget> createState() => _SerialDetailsWidgetState();
}

class _SerialDetailsWidgetState extends State<SerialDetailsWidget> {
  @override
  void initState() {
    super.initState();
    final model = NotifierProvider.read<SerialDetailsModel>(context);
    final appModel = Provider.read<MyAppModel>(context);
    model?.onSessionExpired = () => appModel?.resetSession(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotifierProvider.read<SerialDetailsModel>(context)?.setupLocale(context);
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
    final model = NotifierProvider.watch<SerialDetailsModel>(context);
    return Text(model?.serialDetails?.name ?? 'load..');
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SerialDetailsModel>(context);
    final serialDetails = model?.serialDetails;
    if (serialDetails == null) {
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
