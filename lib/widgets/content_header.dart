import 'package:flutter/material.dart';
import 'package:netflix_ui/models/content_model.dart';
import 'package:netflix_ui/widgets/responsive.dart';
import 'package:netflix_ui/widgets/vertical_icon_button.dart';
import 'package:video_player/video_player.dart';

class ContentHeader extends StatelessWidget {
  final Content featureContent;

  const ContentHeader({super.key, required this.featureContent});
  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _ContentHeaderMobile(featureContent: featureContent),
        tablet: _ContentHeaderMobile(featureContent: featureContent),
        desktop: _ContentHeaderDesktop(featureContent: featureContent));
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.fromLTRB(25.0, 15.0, 30.0, 15.0)
            : const EdgeInsets.fromLTRB(15.0, 5.0, 200, 5.0),
        backgroundColor: Colors.white,
        primary: Colors.black87,
      ),
      onPressed: () => print("Play"),
      icon: const Icon(Icons.play_arrow),
      label: const Text(
        "Play",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
      ),
    );
  }
}

class _ContentHeaderMobile extends StatelessWidget {
  final Content featureContent;

  const _ContentHeaderMobile({super.key, required this.featureContent});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(featureContent.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 500.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 110.0,
          child: SizedBox(
            width: 250.0,
            child: Image.asset(featureContent.titleImageUrl),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VerticalIconButton(
                icon: Icons.add,
                title: "List",
                onTap: () => print("My List"),
              ),
              const _PlayButton(),
              VerticalIconButton(
                icon: Icons.info_outline,
                title: "Info",
                onTap: () => print("Info"),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _ContentHeaderDesktop extends StatefulWidget {
  final Content featureContent;

  const _ContentHeaderDesktop({super.key, required this.featureContent});

  @override
  State<_ContentHeaderDesktop> createState() => _ContentHeaderDesktopState();
}

class _ContentHeaderDesktopState extends State<_ContentHeaderDesktop> {
  late VideoPlayerController _videoPlayerController;
  bool _isMuted = true;
  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.network(widget.featureContent.videoUrl)
          ..initialize().then((_) => setState(() {}))
          ..setVolume(0)
          ..play();

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _videoPlayerController.value.isPlaying
          ? _videoPlayerController.pause()
          : _videoPlayerController.play(),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          AspectRatio(
            aspectRatio: _videoPlayerController.value.isInitialized
                ? _videoPlayerController.value.aspectRatio
                : 2.344,
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Image.asset(
                    widget.featureContent.imageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -1.0,
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.isInitialized
                  ? _videoPlayerController.value.aspectRatio
                  : 2.344,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 60,
            right: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250.0,
                  child: Image.asset(
                    widget.featureContent.titleImageUrl,
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  widget.featureContent.description,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2.0, 4.0),
                          blurRadius: 6.0,
                        )
                      ]),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const _PlayButton(),
                    const SizedBox(width: 16.0),
                    TextButton.icon(
                      onPressed: () => print('More Info'),
                      icon: const Icon(Icons.info_outline),
                      label: const Text(
                        "More Info",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      style: TextButton.styleFrom(
                        padding: Responsive.isDesktop(context)
                            ? const EdgeInsets.fromLTRB(25.0, 15.0, 30.0, 15.0)
                            : const EdgeInsets.fromLTRB(15.0, 5.0, 200, 5.0),
                        primary: Colors.black87,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    if (_videoPlayerController.value.isInitialized)
                      IconButton(
                        onPressed: () => setState(() {
                          _isMuted
                              ? _videoPlayerController.setVolume(100)
                              : _videoPlayerController.setVolume(0);
                          _isMuted = _videoPlayerController.value.volume == 0;
                        }),
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                        ),
                        splashColor: Colors.transparent,
                      )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
