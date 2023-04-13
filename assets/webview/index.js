var root = am5.Root.new("chartdiv");

root.setThemes([
  am5themes_Animated.new(root)
]);

var container = root.container.children.push(am5.Container.new(root, {
  width: am5.percent(100),
  height: am5.percent(100),
  layout: root.verticalLayout
}));


// Create series
// https://www.amcharts.com/docs/v5/charts/hierarchy/#Adding
var series = container.children.push(am5hierarchy.ForceDirected.new(root, {
  singleBranchOnly: false,
  downDepth: 1,
  initialDepth: 2,
  valueField: "value",
  categoryField: "name",
  childDataField: "children"
}));


// Generate and set data
// https://www.amcharts.com/docs/v5/charts/hierarchy/#Setting_data
var maxLevels = 2;
var maxNodes = 3;
var maxValue = 100;

var data = {
  name: "Root",
  children: []
}
generateLevel(data, "", 0);

series.data.setAll([data]);
series.set("selectedDataItem", series.dataItems[0]);

function generateLevel(data, name, level) {
  for (var i = 0; i < Math.ceil(maxNodes * Math.random()) + 1; i++) {
    var nodeName = name + "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[i];
    var child;
    if (level < maxLevels) {
      child = {
        name: nodeName + level
      }

      if (level > 0 && Math.random() < 0.5) {
        child.value = Math.round(Math.random() * maxValue);
      }
      else {
        child.children = [];
        generateLevel(child, nodeName + i, level + 1)
      }
    }
    else {
      child = {
        name: name + i,
        value: Math.round(Math.random() * maxValue)
      }
    }
    data.children.push(child);
  }

  level++;
  return data;
}


// Make stuff animate on load
series.appear(1000, 100);



















// am5.ready(function () {
//   var root = am5.Root.new("chartdiv");

//   root.setThemes([
//     am5themes_Animated.new(root)
//   ]);

var data = {
  name: "Root",
  value: 0,
  children: [
    {
      name: "1",
      linkWith: ["2"],
      children: [
        {
          name: "A",
          children: [
            { name: "A1", value: 1 },
            { name: "A2", value: 1 },
            { name: "A3", value: 1 },
            { name: "A4", value: 1 },
            { name: "A5", value: 1 }
          ]
        },
        {
          name: "B",
          children: [
            { name: "B1", value: 1 },
            { name: "B2", value: 1 },
            { name: "B3", value: 1 },
            { name: "B4", value: 1 },
            { name: "B5", value: 1 }
          ]
        },
        {
          name: "C",
          children: [
            { name: "C1", value: 1 },
            { name: "C2", value: 1 },
            { name: "C3", value: 1 },
            { name: "C4", value: 1 },
            { name: "C5", value: 1 }
          ]
        }
      ]
    },

    {
      name: "2",
      linkWith: ["3"],
      children: [
        {
          name: "D", value: 1
        },
        {
          name: "E", value: 1
        }
      ]
    },
    {
      name: "3",
      children: [
        {
          name: "F",
          children: [
            { name: "F1", value: 1 },
            { name: "F2", value: 1 },
            { name: "F3", value: 1 },
            { name: "F4", value: 1 },
            { name: "F5", value: 1 }
          ]
        },
        {
          name: "H",
          children: [
            { name: "H1", value: 1 },
            { name: "H2", value: 1 },
            { name: "H3", value: 1 },
            { name: "H4", value: 1 },
            { name: "H5", value: 1 }
          ]
        },
        {
          name: "G",
          children: [
            { name: "G1", value: 1 },
            { name: "G2", value: 1 },
            { name: "G3", value: 1 },
            { name: "G4", value: 1 },
            { name: "G5", value: 1 }
          ]
        }
      ]
    }
  ]
};

//   // Create wrapper container
//   var container = root.container.children.push(
//     am5.Container.new(root, {
//       width: am5.percent(100),
//       height: am5.percent(100),
//       layout: root.verticalLayout
//     })
//   );

//   // Create series
//   var series = container.children.push(
//     am5hierarchy.ForceDirected.new(root, {
//       singleBranchOnly: false,
//       downDepth: 1,
//       topDepth: 1,
//       maxRadius: 25,
//       minRadius: 12,
//       valueField: "value",
//       categoryField: "name",
//       childDataField: "children",
//       idField: "name",
//       linkWithStrength: 0.3,
//       linkWithField: "linkWith",
//       manyBodyStrength: -15,
//       centerStrength: 0.5
//     })
//   );

//   series.get("colors").set("step", 2);
//   series.data.setAll([data]);
//   series.set("selectedDataItem", series.dataItems[0]);
//   series.appear(1000, 100);

// }); // end am5.ready()