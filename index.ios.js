var React = require('react-native');
 
// 1
var {
  Component,
  AppRegistry,
  StyleSheet,
  Text,
  TextInput,
  View,
} = React;
 
// 2
var SecondScreenUtil = require('NativeModules').RRSecondScreenUtil;
 
class rr_nativeModules extends Component {
  // 3
  constructor(props) {
    super(props);
    this.state = {
      number: 0
    };
  }
 
  // 4
  render() {
    return (
      <View style={styles.container}>
      <Text style={styles.welcome}>
      {SecondScreenUtil.greeting}
      </Text>
      <TextInput style={styles.input} onChangeText={(text) => this.squareMe(text)}/>
      <Text style={styles.result}>
      {this.state.number}
      </Text>
      <Text onPress={() => this.isSecondScreenConnected()}>Click me to check!</Text>
      <Text onPress={() => this.sendEventToSecondScreen()}>Click to send event</Text>
      </View>
    );
  }
 
  // 5
  squareMe(num) {
    if (num == '') {
      return;
    }
    SecondScreenUtil.squareMe(parseInt(num, 10), (error, number) => {
      if (error) {
        console.error(error);
      } else {
        this.setState({number: number});
      }
    })
  }
  
  isSecondScreenConnected() {
    SecondScreenUtil.isSecondScreenConnected((error, is_connected) => {
        alert('Screen is connected: ' + is_connected);
    })
  }
  
  sendEventToSecondScreen() {
    SecondScreenUtil.sendEventToSecondScreen('my_event', {a:11, b: 22}, (error) => {
        if (error) {
            alert('Oh no error!');
        } else {
            alert('Sent!');
        }
    })
  }
};
 
// 6
var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 20,
  },
  input: {
    width: 100,
    height: 40,
    borderColor: 'red',
    borderWidth: 1,
    alignSelf: 'center'
  },
  result: {
    textAlign: 'center',
    color: '#333333',
    fontSize: 30,
    fontWeight: 'bold',
    margin: 20,
  },
});
 
AppRegistry.registerComponent('rr_nativeModules', () => rr_nativeModules);