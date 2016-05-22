# react-native-external-screen
This is a simple proof of concept for adding support for external-screen ("second screen")
for react-native on iOS.

## Quick install
1. Import RRSecondScreenUtil.h and RRSecondScreenUtil.m into your Xcode project.
2. Include in your index.ios.js, example:
```
var SecondScreenUtil = require('NativeModules').RRSecondScreenUtil;
class rr_nativeModules extends Component {
  isSecondScreenConnected() {
    SecondScreenUtil.isSecondScreenConnected((error, is_connected) => {
        alert('Screen is connected: ' + is_connected);
    })
  }
  
  sendEventToSecondScreen() {
    SecondScreenUtil.sendEventToSecondScreen('my_event', {a:11, b: 22}, (error) => {
        if (!error) {
            alert('Sent event to second screen!');
        }
    })
  }
}
AppRegistry.registerComponent('rr_nativeModules', () => rr_nativeModules);
´´´
3. Create a view for external screen with path (web/second-screen.html), and create a listener for the event callback:
```
# web/second-screen.html
...
<script type="text/javascript">
    window.rr_ss_callback = function(event_name, args) {
        console.log('event_name: ', event_name);
        console.log('args: ', args);
    }
</script>
...
´´


