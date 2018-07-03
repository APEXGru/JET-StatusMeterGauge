# Oracle APEX Region Plugin - StatusMeterGauge
Region Plugin to show one or more Status Meter Gauges based on a SQL statement.


## Changelog

#### 1.2.0 - Fix for APEX 18.1 / JET 4.2
#### 1.1.0 - Added a "Tooltip" column
#### 1.0.0 - Initial Release


## Install

- Import Plugin File **region_type_plugin_com_apexconsulting_apex_jet_gauge.sql** from the main directory into your Application
- (Optional) Deploy the JS and CSS files from the **server/js** and **server/css** Directory on your Webserver and change the **File Prefix** to Webservers Folder.


## Plugin Settings

Available Plugin Settings :
- **Value column** - the name or alias of the column that should be used as the value (required)
- **Percent column** - the name or alias of the column that should be used as the percent value (can be the same as the Value Column)(required)
- **Label column** - the name or alias of the column that should be used as the label (optional)
- **Color column** - the name or alias of the column that should be used as the color column (optional)
- **Tooltip column** - the name or alias of the column that should be used as the tooltip column (optional)
- **Link target** - standard APEX link target option (optional)
- **Orientation** - should the gauges be horizontally or verticaly rendered (required)
- **Height** - the height of the gauge (can be restricted by the available height for the region) (required)
- **Automatic refresh** - refresg after x seconds (optional)


## How to use
- Create a new Region based on the Plugin
- Add a SQL Statement like the example below. Then map the columns to the correct attributes.
```
select round(dbms_random.value(0,100))     val
,      dbms_random.string('l', 10)  txt
,      '#' || round(dbms_random.value(100000,999999)) color
from   dual
connect by level <= 3
```

## Demo Application
[https://apex.oracle.com/pls/apex/f?p=ROELSAPEXJET:STATUSMETERGAUGE](https://apex.oracle.com/pls/apex/f?p=ROELSAPEXJET:STATUSMETERGAUGE)


## Related info
Based upon the Status Meter Gauge JET component, see [http://www.oracle.com/webfolder/technetwork/jet/jetCookbook.html?component=statusMeterGauge&demo=statusMeterGaugeCircular](http://www.oracle.com/webfolder/technetwork/jet/jetCookbook.html?component=statusMeterGauge&demo=statusMeterGaugeCircular) for details.


## Preview
## ![](https://github.com/APEXGru/JET-StatusMeterGauge/raw/master/preview.png)
