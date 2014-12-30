
window.screen.mozLockOrientation && window.screen.mozLockOrientation("landscape");

function getJSON(url, callback) {
  var xhr = new XMLHttpRequest({mozSystem: true});
  xhr.open('GET', url, true);
  xhr.onload = function() {
    if (this.status >= 200 && this.status < 400){
      data = JSON.parse(this.response);
      console.log('AJAX Loaded');
      callback(data);
    } else {
      console.log('AJAX error: '+this.status);
      console.log(this);
    }
  };
  xhr.send();
}

var Weather = React.createClass({
  render: function() {
    return (
      <div className='flex'>
        <h1 className='temp'>{this.state.current}<br/>{this.state.high}</h1>
        <h2 className={this.state.weather_class}><br/><span>{this.state.text}</span></h2>
      </div>
    );
  },
  getInitialState: function() {
    return {
      high: '..',
      current: '..',
      weather_class: '..'
    };
  },
  componentDidMount: function() {
    getJSON(this.props.source, function(data) {
      forecast = data.query.results.channel.item.forecast[0];
      current_temp = data.query.results.channel.item.condition.temp;
      console.log(data);
      if (this.isMounted()) {
        this.setState({
          weather_class: "klimato-" + forecast.code,
          date: forecast.date,
          day: forecast.day,
          current: current_temp,
          high: forecast.high,
          text: forecast.text,
        });
      }
    }.bind(this));
  },
});


format = 'c';
woeid  = 1103816;

source = 'http://query.yahooapis.com/v1/public/yql?q=';
source += "select * from weather.forecast WHERE woeid=22720989 and u='c'&format=json";

React.render(
  <Weather source={source} />,
  document.getElementById('weather')
);
