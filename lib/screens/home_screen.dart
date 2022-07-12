import 'package:flutter/material.dart';
import 'package:netflix_ui/cubits/app_bar/app_bar_cubit.dart';
import 'package:netflix_ui/data/data.dart';
import 'package:netflix_ui/widgets/content_header.dart';
import 'package:netflix_ui/widgets/content_list.dart';
import 'package:netflix_ui/widgets/custom_app_bar.dart';
import 'package:netflix_ui/widgets/previews.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        context.read<AppBarCubit>().setOffset(_scrollController.offset);
        // setState(() {
        //   _scrollOffset = _scrollController.offset;
        // });
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.cast),
        onPressed: () => print("cast"),
      ),
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: BlocBuilder<AppBarCubit, double>(
          builder: ((context, scrollOffset) {
            return CustomAppBar(scrollOffset: scrollOffset);
          }),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: const [
          SliverToBoxAdapter(
            child: ContentHeader(featureContent: sintelContent),
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: Previews(
                  key: PageStorageKey("previews"),
                  contentList: previews,
                  title: "Previews"),
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              key: PageStorageKey("myList"),
              title: 'My List',
              contentList: myList,
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              key: PageStorageKey("originals"),
              title: 'Netflix Originals',
              contentList: originals,
              isOriginal: true,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 20.0),
            sliver: SliverToBoxAdapter(
              child: ContentList(
                key: PageStorageKey("trending"),
                title: "Trending",
                contentList: trending,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
