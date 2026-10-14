import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import 'app_icon.dart';
import 'motion.dart';

/// Frosted translucent backdrop.
class GlassBackdrop extends StatelessWidget {
  const GlassBackdrop({
    super.key,
    this.opacity = 1,
    this.sigma = 20,
    this.tint = const Color(0xC7F9F5EC),
    this.borderTop = false,
    this.borderBottom = false,
  });

  final double opacity;
  final double sigma;
  final Color tint;
  final bool borderTop;
  final bool borderBottom;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0).toDouble(),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tint,
              border: Border(
                top: borderTop ? const BorderSide(color: AppColors.borderSoft) : BorderSide.none,
                bottom: borderBottom ? const BorderSide(color: AppColors.borderSoft) : BorderSide.none,
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

/// Round frosted icon button (used over photos and as a bar action).
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.size = 40,
    this.dark = false,
  });

  final String icon;
  final VoidCallback onTap;
  final bool filled;
  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.92,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            color: dark ? const Color(0x4D000000) : const Color(0xB3FFFFFF),
            child: AppIcon(icon,
                size: 20, filled: filled, color: dark ? Colors.white : AppColors.ink),
          ),
        ),
      ),
    );
  }
}

/// Scrollable page with a large title that collapses into a blurred, translucent
/// header. Uses the real device insets. Content scrolls *under* the header.
class GlassPage extends StatefulWidget {
  const GlassPage({
    super.key,
    this.title,
    this.largeTitle = true,
    this.showBack = false,
    this.trailing,
    required this.children,
    this.bottomPadding = 32,
    this.bottomBar,
  });

  final String? title;
  final bool largeTitle;
  final bool showBack;
  final Widget? trailing;
  final List<Widget> children;
  final double bottomPadding;

  /// Optional widget pinned to the bottom (e.g. the tab bar).
  final Widget? bottomBar;

  static const barHeight = 56.0;

  @override
  State<GlassPage> createState() => _GlassPageState();
}

class _GlassPageState extends State<GlassPage> {
  final _controller = ScrollController();
  double _t = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final t = (_controller.hasClients ? _controller.offset / 36 : 0.0).clamp(0.0, 1.0).toDouble();
      if ((t - _t).abs() > 0.01) setState(() => _t = t);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasBar => widget.showBack || widget.trailing != null || widget.title != null;

  @override
  Widget build(BuildContext context) {
    final top = Insets.top(context);
    final barH = _hasBar ? GlassPage.barHeight : 0.0;
    final collapsedTitleOpacity = widget.largeTitle ? _t : 1.0;

    return Stack(
      children: [
        Positioned.fill(
          child: ListView(
            controller: _controller,
            primary: false,
            padding: EdgeInsets.only(top: top + barH, bottom: widget.bottomPadding),
            children: [
              if (widget.largeTitle && widget.title != null)
                FadeSlideIn(
                  dy: 8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(Insets.page, 4, Insets.page, 16),
                    child: Text(widget.title!, style: AppText.t(30, w: FontWeight.w600, lh: 36)),
                  ),
                )
              else
                const SizedBox(height: 4),
              ...widget.children,
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: top + barH,
          child: Stack(
            children: [
              Positioned.fill(child: GlassBackdrop(opacity: _t, borderBottom: true)),
              if (_hasBar)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: barH,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        if (widget.showBack)
                          _BackButton(onTap: () => Navigator.of(context).maybePop())
                        else
                          const SizedBox(width: 8),
                        Expanded(
                          child: Opacity(
                            opacity: collapsedTitleOpacity,
                            child: Text(
                              widget.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: widget.showBack ? TextAlign.center : TextAlign.left,
                              style: AppText.t(16, w: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(width: 44, child: widget.trailing),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (widget.bottomBar != null)
          Positioned(left: 0, right: 0, bottom: 0, child: widget.bottomBar!),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.88,
      child: const SizedBox(
        width: 44,
        height: 44,
        child: Center(child: AppIcon('left', size: 24)),
      ),
    );
  }
}

/// Standalone back arrow used on custom headers.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) =>
      _BackButton(onTap: onTap ?? () => Navigator.of(context).maybePop());
}
