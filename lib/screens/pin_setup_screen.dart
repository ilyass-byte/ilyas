import 'package:flutter/material.dart';
import '../core/language.dart';
import '../core/security_manager.dart';

class PinSetupScreen extends StatefulWidget {
  final VoidCallback? onPinSetup;
  final bool isChangingPin;

  const PinSetupScreen({
    super.key,
    this.onPinSetup,
    this.isChangingPin = false,
  });

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  String _currentPin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _statusMessage =
        widget.isChangingPin
            ? 'Enter your new 4-digit PIN'
            : 'Create a 4-digit PIN to secure your app';

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (_isLoading) return;

    setState(() {
      if (!_isConfirming) {firming) {
        if (_currentPin.length < 4) {gth < 4) {
          _currentPin += number;
          if (_currentPin.length == 4) { == 4) {
            _isConfirming = true;
            _statusMessage = 'Confirm your PIN';firm your PIN';
          }
        }
      } else {lse {
        if (_confirmPin.length < 4) {onfirmPin.length < 4) {
          _confirmPin += number;
          if (_confirmPin.length == 4) { == 4) {
            _validatePin();
          }
        }
      }
    });
  }

  void _onDeletePressed() {  void _onDeletePressed() {
    if (_isLoading) return;

    setState(() {    setState(() {
      if (!_isConfirming) {firming) {
        if (_currentPin.isNotEmpty) {otEmpty) {
          _currentPin = _currentPin.substring(0, _currentPin.length - 1);ubstring(0, _currentPin.length - 1);
        }
      } else {lse {
        if (_confirmPin.isNotEmpty) {onfirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);ubstring(0, _confirmPin.length - 1);
        }
      }
    });
  }

  void _onClearPressed() {  void _onClearPressed() {
    if (_isLoading) return;;

    setState(() {    setState(() {
      if (_isConfirming) {irming) {
        _isConfirming = false;lse;
        _confirmPin = '';
        _statusMessage =
            widget.isChangingPinngingPin
                ? 'Enter your new 4-digit PIN'w 4-digit PIN'
                : 'Create a 4-digit PIN to secure your app';ure your app';
      } else {
        _currentPin = '';ntPin = '';
      }
    });
  }

  Future<void> _validatePin() async {  Future<void> _validatePin() async {
    if (_currentPin != _confirmPin) {
      setState(() {
        _statusMessage = 'PINs do not match. Try again.';age = 'PINs do not match. Try again.';
        _isConfirming = false;
        _currentPin = '';
        _confirmPin = '';
      });

      // Shake animation      // Shake animation
      _animationController.reset();er.reset();
      _animationController.forward(););
      return;
    }

    setState(() {    setState(() {
      _isLoading = true;= true;
      _statusMessage = 'Setting up your PIN...';Setting up your PIN...';
    });

    try {    try {
      await SecurityManager.instance.setPinCode(_currentPin);it SecurityManager.instance.setPinCode(_currentPin);
      await SecurityManager.instance.setPinEnabled(true);

      setState(() {      setState(() {
        _statusMessage = 'PIN setup successful!';age = 'PIN setup successful!';
      });

      await Future.delayed(const Duration(milliseconds: 1000));      await Future.delayed(const Duration(milliseconds: 1000));

      if (widget.onPinSetup != null) {      if (widget.onPinSetup != null) {
        widget.onPinSetup!();
      }

      if (mounted) {      if (mounted) {
        Navigator.pop(context, true);p(context, true);
      }
    } catch (e) {atch (e) {
      setState(() { {
        _statusMessage = 'Error setting up PIN. Please try again.';age = 'Error setting up PIN. Please try again.';
        _isLoading = false;
        _isConfirming = false;se;
        _currentPin = '';
        _confirmPin = '';
      });
    }
  }

  @override  @override
  Widget build(BuildContext context) {ild(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),r: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,or: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),eInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(adient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],olor(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,t,
            ),
            borderRadius: BorderRadius.circular(16.0),rderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.3),onst Color(0xFF667EEA).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(ild: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(tle: Text(
          widget.isChangingPin ? 'Change PIN' : 'Setup PIN',hangingPin ? 'Change PIN' : 'Setup PIN',
          style: const TextStyle(
            color: Color(0xFF2D3748),48),
            fontWeight: FontWeight.bold,ld,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(dy: SafeArea(
        child: Padding(g(
          padding: const EdgeInsets.all(24.0),t EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),cer(),

              // Header              // Header
              FadeTransition(ition(
                opacity: _fadeAnimation,eAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,n,
                  child: Container(
                    width: 100,
                    height: 100,,
                    decoration: BoxDecoration(BoxDecoration(
                      gradient: const LinearGradient(adient(
                        colors: [Color(0xFF2196F3), Color(0xFF1976D2)],olor(0xFF1976D2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,t,
                      ),
                      borderRadius: BorderRadius.circular(25),rderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2196F3).withOpacity(0.3),onst Color(0xFF2196F3).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),ffset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(ild: const Icon(
                      Icons.pin_rounded,d,
                      size: 50,
                      color: Colors.white,lors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),              const SizedBox(height: 32),

              // Status Message              // Status Message
              FadeTransition(
                opacity: _fadeAnimation,eAnimation,
                child: Text(
                  _statusMessage,sage,
                  style: const TextStyle(xtStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,ontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,xtAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),              const SizedBox(height: 40),

              // PIN Display              // PIN Display
              FadeTransition((
                opacity: _fadeAnimation,eAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,lignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final currentLength =
                        _isConfirming ? _confirmPin.length : _currentPin.length;confirmPin.length : _currentPin.length;
                    final isFilled = index < currentLength;

                    return Container(                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),dgeInsets.symmetric(horizontal: 8),
                      width: 20,
                      height: 20,,
                      decoration: BoxDecoration( BoxDecoration(
                        color:
                            isFilledFilled
                                ? const Color(0xFF2196F3)nst Color(0xFF2196F3)
                                : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),circular(10),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 60),              const SizedBox(height: 60),

              // Number Pad              // Number Pad
              FadeTransition(opacity: _fadeAnimation, child: _buildNumberPad()),n(opacity: _fadeAnimation, child: _buildNumberPad()),

              const Spacer(),              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {  Widget _buildNumberPad() {
    return Column(
      children: [
        // Numbers 1-3s 1-3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,inAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              [
                '1', '1',
                '2',
                '3',
              ].map((number) => _buildNumberButton(number)).toList(),(number) => _buildNumberButton(number)).toList(),
        ),
        const SizedBox(height: 20),nst SizedBox(height: 20),

        // Numbers 4-6        // Numbers 4-6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,inAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              [
                '4', '4',
                '5',
                '6',
              ].map((number) => _buildNumberButton(number)).toList(),(number) => _buildNumberButton(number)).toList(),
        ),
        const SizedBox(height: 20),nst SizedBox(height: 20),

        // Numbers 7-9        // Numbers 7-9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,inAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              [
                '7', '7',
                '8',
                '9',
              ].map((number) => _buildNumberButton(number)).toList(),(number) => _buildNumberButton(number)).toList(),
        ),
        const SizedBox(height: 20),nst SizedBox(height: 20),

        // Clear, 0, Delete        // Clear, 0, Delete
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,inAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(ionButton(
              icon: Icons.clear_rounded,_rounded,
              onPressed: _onClearPressed,,
            ),
            _buildNumberButton('0'),uildNumberButton('0'),
            _buildActionButton(
              icon: Icons.backspace_rounded,pace_rounded,
              onPressed: _onDeletePressed,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),rPressed(number),
      child: Container(
        width: 70,
        height: 70,,
        decoration: BoxDecoration( BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),Radius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),olors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),Offset(0, 4),
            ),
          ],
        ),
        child: Center(ild: Center(
          child: Text(
            number,
            style: const TextStyle(const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,ontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,nPressed,
  }) {
    return GestureDetector(turn GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 70,,
        decoration: BoxDecoration( BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(35),us.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),olors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),Offset(0, 4),
            ),
          ],
        ),
        child: Center(ild: Center(
          child: Icon(icon, size: 24, color: const Color(0xFF2D3748)),icon, size: 24, color: const Color(0xFF2D3748)),
        ),
      ),
    );
  }
}
