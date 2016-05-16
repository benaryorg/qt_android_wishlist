import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

ApplicationWindow
{
	id: root
	visible: true
	width: 640
	height: 480
	title: qsTr("Wishlist")

	property real sum: 0
	property string objname: ""
	property string objdesc: ""
	property real objprice: 0.0

	toolBar: ToolBar
	{
		RowLayout
		{
			anchors.fill: parent
			Label
			{
				Layout.fillWidth: true
				text: root.title
			}
			Button
			{
				text: qsTr("Sum")
				onClicked:
				{
					var sum = 0;
					var i;
					for(i=0;i<lmodel.count;i++)
					{
						sum += lmodel.get(i).price;
					}
					root.sum = sum;
					msgsum.open();
				}
			}
			Button
			{
				text: qsTr("Quit")
				onClicked: Qt.quit()
			}
		}
	}

	ListModel
	{
		id: lmodel

		ListElement
		{
			name: "Car"
			price: 199999
			desc: "Brumm Brumm"
		}
	}

	TabView
	{
		id: tabview
		anchors.fill: parent

		Tab
		{
			anchors.fill: parent
			title: qsTr("Wishes")
			ListView
			{
				anchors.fill: parent
				model: lmodel
				delegate: RowLayout
				{
					anchors.left: parent.left
					anchors.right: parent.right
					Layout.fillWidth: true

					Label
					{
						text: name
						wrapMode: Text.Wrap
						Layout.fillWidth: true
					}

					Label
					{
						text: price.toFixed(2)
						wrapMode: Text.Wrap
					}

					Button
					{
						text: qsTr("Edit")
						onClicked:
						{
							objname = name;
							objdesc = desc;
							objprice = price;
							edittab.index = index;
							edittab.editable = false;
							tabview.currentIndex++;
						}
					}

					Button
					{
						text: qsTr("Delete")
						onClicked: lmodel.remove(index)
					}
				}
			}
		}

		Tab
		{
			id: edittab
			property bool editable: true
			property int index: 0

			title: qsTr("Add Wish")

			ColumnLayout
			{
				id: collayout
				anchors.fill: parent
				Layout.fillWidth: true

				TextField
				{
					id: editname
					Layout.fillWidth: true
					text: objname
					enabled: edittab.editable
					placeholderText: qsTr("Name")
					validator: RegExpValidator
					{
						regExp: /.+/
					}
				}

				TextField
				{
					id: editdesc
					Layout.fillWidth: true
					text: objdesc
					enabled: edittab.editable
					placeholderText: qsTr("Description")
					validator: RegExpValidator
					{
						regExp: /.+/
					}
				}

				TextField
				{
					id: editprice
					Layout.fillWidth: true
					text: objprice
					placeholderText: qsTr("Price")
					validator: DoubleValidator{}
					inputMethodHints: Qt.ImhFormattedNumbersOnly
				}

				Button
				{
					visible: edittab.editable
					text: qsTr("Add to List")
					enabled: editname.acceptableInput && editdesc.acceptableInput && editprice.acceptableInput
					onClicked:
					{
						lmodel.append({"name":editname.text,"desc":editdesc.text,"price":parseFloat(editprice.text)});
						editname.text = "";
						editdesc.text = "";
						editprice.text = "";
						objname = "";
						objdesc = "";
						objprice = "";
						tabview.currentIndex--;
					}
				}

				Button
				{
					visible: !edittab.editable
					text: qsTr("Save")
					onClicked:
					{
						lmodel.set(index,{"name":editname.text,"desc":editdesc.text,"price":parseFloat(editprice.text)});
						editname.text = "";
						editdesc.text = "";
						editprice.text = "";
						objname = "";
						objdesc = "";
						objprice = "";
						tabview.currentIndex--;
						edittab.editable = true;
					}
				}

				Button
				{
					text: qsTr("Cancel")
					onClicked:
					{
						editname.text = "";
						editdesc.text = "";
						editprice.text = "";
						objname = "";
						objdesc = "";
						objprice = "";
						tabview.currentIndex--;
						edittab.editable = true;
					}
				}

				Item
				{
					Layout.fillHeight: true
				}
			}
		}
	}

	MessageDialog
	{
		id: msgsum
		title: qsTr("Sum of all Wishes")
		text: qsTr("The sum of all wishes is ")+root.sum.toFixed(2)
	}
}
