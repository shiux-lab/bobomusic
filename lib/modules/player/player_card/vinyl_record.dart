import "dart:math";
import "package:flutter/material.dart";

class VinylRecordWidget extends StatefulWidget {
  final String albumCoverUrl;
  final String errorAlbumCoverUrl;
  final bool isPlaying;

  const VinylRecordWidget({
    super.key,
    required this.albumCoverUrl,
    required this.errorAlbumCoverUrl,
    required this.isPlaying,
  });

  @override
  VinylRecordWidgetState createState() => VinylRecordWidgetState();
}

class VinylRecordWidgetState extends State<VinylRecordWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  ImageProvider? _imageProvider;
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;
  late ImageStreamListener _imageStreamListener;
  ImageInfo? _localImageInfo;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _rotationAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );

    if (widget.isPlaying) {
      _animationController.repeat(reverse: false);
    }

    _imageProvider = NetworkImage(widget.albumCoverUrl);
    _imageStreamListener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        setState(() {
          _imageInfo = info;
        });
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        print("Image loading error: $exception");
        _loadLocalImage();
      },
    );
    _loadImage();
    _loadLocalImage();
  }

  void _loadImage() {
    _imageStream = _imageProvider?.resolve(const ImageConfiguration());
    _imageStream?.addListener(_imageStreamListener);
  }

  void _loadLocalImage() {
    final ImageProvider localImageProvider = AssetImage(widget.errorAlbumCoverUrl);
    localImageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          setState(() {
            _localImageInfo = info;
          });
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant VinylRecordWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
    if (widget.albumCoverUrl != oldWidget.albumCoverUrl) {
      _imageProvider = NetworkImage(widget.albumCoverUrl);
      _loadImage();
    }
    if (widget.errorAlbumCoverUrl != oldWidget.errorAlbumCoverUrl) {
      _loadLocalImage();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _imageStream?.removeListener(_imageStreamListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final screenWidth = screenSize.width;
    final containerSize = screenWidth * 0.9;
    final recordSize = containerSize * 0.9;

    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: containerSize / 2,
              height: containerSize,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                boxShadow: isLandscape ? null : const [
                  BoxShadow(
                    color: Color.fromARGB(255, 50, 50, 50),
                    offset: Offset(5, 3),
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(isLandscape ? 8 : 4)),
                image: _imageInfo != null
                  ? DecorationImage(
                      image: _imageProvider!,
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: AssetImage(widget.errorAlbumCoverUrl),
                      fit: BoxFit.cover,
                    ),
              ),
            ),
            if (!isLandscape)
              ClipRect(
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 0.5,
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: CustomPaint(
                      size: Size(recordSize, recordSize),
                      painter: VinylRecordPainter(
                        imageInfo: _imageInfo,
                        localImageInfo: _localImageInfo,
                        albumCoverSize: Size(containerSize, containerSize),
                        localImagePath: widget.errorAlbumCoverUrl,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}

class VinylRecordPainter extends CustomPainter {
  final ImageInfo? imageInfo;
  final ImageInfo? localImageInfo;
  final Size albumCoverSize;
  final String localImagePath;

  VinylRecordPainter({
    required this.imageInfo,
    required this.localImageInfo,
    required this.albumCoverSize,
    required this.localImagePath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 绘制黑胶背景
    final backgroundPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // 创建固定随机种子
    final random = Random(12345);

    // 绘制纹路和磨损点
    for (double r = radius * 0.2; r < radius * 0.9; r += 5) {
      final brightness = 1.0 - (r / radius);
      final randomColor = Color.fromRGBO(
        (20 + (r % 30) * brightness).toInt(),
        (20 + (r % 30) * brightness).toInt(),
        (20 + (r % 30) * brightness).toInt(),
        1,
      );

      // 主纹路
      final groovePaint = Paint()
        ..color = randomColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = (1 + (r % 3) / 3);
      canvas.drawCircle(center, r, groovePaint);

      // 添加磨损点
      const angleStep = 2 * pi / 3; // 3个点/环
      final baseAngle = random.nextDouble() * 2 * pi;
      for (int i = 0; i < 8; i++) {
        if (random.nextDouble() > 0.6) continue; // 40%概率跳过

        final angle = baseAngle + i * angleStep + random.nextDouble() * 0.2 - 0.1;
        final dotRadius = r + random.nextDouble() * 4 - 2;
        final position = Offset(
          center.dx + dotRadius * cos(angle),
          center.dy + dotRadius * sin(angle),
        );

        final dotPaint = Paint()
          // ignore: deprecated_member_use
          ..color = randomColor.withOpacity(0.8)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          position,
          1.5 + random.nextDouble() * 1.5, // 1.5-3px
          dotPaint,
        );
      }
    }

    // 专辑封面
    final coverRadius = radius * 0.25;
    final coverRect = Rect.fromCircle(center: center, radius: coverRadius);
    final path = Path()..addOval(coverRect);
    canvas.clipPath(path);

    final ImageInfo? targetImage = imageInfo ?? localImageInfo;
    if (targetImage != null) {
      final sourceSize = Size(
        targetImage.image.width.toDouble(),
        targetImage.image.height.toDouble(),
      );
      final fitted = applyBoxFit(BoxFit.cover, sourceSize, coverRect.size);
      final sourceRect = Alignment.center.inscribe(fitted.source, Offset.zero & sourceSize);
      final destRect = Alignment.center.inscribe(fitted.destination, coverRect);

      canvas.drawImageRect(targetImage.image, sourceRect, destRect, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant VinylRecordPainter oldDelegate) {
    return oldDelegate.imageInfo != imageInfo ||
        oldDelegate.localImageInfo != localImageInfo;
  }
}
