# react-native-external-screen
This is a simple proof of concept for adding support for external-screen ("second screen", Airplay)
for react-native on iOS.

## Quick install example
### 1. Import objective-c files
Import the files RRSecondScreenUtil.h and RRSecondScreenUtil.m from this repo into your Xcode project.

### 2. Include it in your index.ios.js
This is an example of how you can include the seconscreen into your react code:
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
```
### 3. Create web/second-screen.html
Now, in order to show something on your seconds screen you need to create a web view file at the path 
web/second-screen.html. There you can listen to events from the RRSecondScreenUtil, by declaring a listener method:
```
<!-- web/second-screen.html -->
...
<script type="text/javascript">
    window.rr_ss_callback = function(event_name, args) {
        console.log('event_name: ', event_name);
        console.log('args: ', args);
    }
</script>
...
```
### 4. Some action
Now, by implementing the sendEventToSecondScreen()-method in any of your react components you can
send information to your second screen directly from react native.



