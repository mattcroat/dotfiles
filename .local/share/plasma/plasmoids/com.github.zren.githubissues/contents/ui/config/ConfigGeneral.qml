import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.kirigami 2.5 as Kirigami

import "../lib"

ConfigPage {
	id: page
	showAppletVersion: true

	property var cfg_repoList: []
	property alias cfg_headingText: headingTextField.text
	property alias cfg_updateIntervalInMinutes: updateIntervalInMinutesSpinBox.value

	Component.onCompleted: {
		// console.log('ConfigGeneral.onCompleted')
		// console.log('\t cfg_repoList', cfg_repoList, typeof cfg_repoList)
		// console.log('\t repoListTextField.textAreaText', repoListTextField.textAreaText, typeof repoListTextField.textAreaText)
		// console.log('\t repoListTextField.textArea.text', repoListTextField.textArea.text, typeof repoListTextField.textArea.text)
	}
	// onCfg_repoListChanged: console.log('cfg_repoList onChanged', cfg_repoList, typeof cfg_repoList)

	ColumnLayout {
		Layout.alignment: Qt.AlignTop

		Kirigami.FormLayout {
			Layout.fillWidth: true
			wideMode: true

			ConfigStringList {
				id: repoListTextField
				Kirigami.FormData.label: i18n("Repos:")
				Layout.fillWidth: true
				placeholderText: i18n("User/Repo\nUser/Repo")
				textArea.text: listToStr(cfg_repoList)
				textArea.onTextChanged: {
					// console.log('repoListTextField.onTextChanged', textArea.text)
					// console.log('\t textAreaFocus && writeOnChange', textAreaFocus && writeOnChange)
					if (textAreaFocus && writeOnChange) {
						writeOnChange = false
						cfg_repoList = strToList(textAreaText)
						writeOnChange = true
					}
				}
				property bool writeOnChange: true

				function listToStr(val) {
					// console.log('cfg_repoList R', val, typeof val)
					var str = parseValue(val)
					// console.log('\t str', str, typeof str)
					return str
				}
				function strToList(val) {
					// console.log('cfg_repoList W', val, parseText(val))
					var list = parseText(val)
					// console.log('\t list', list, typeof list)
					return list
				}
			}

			TextField {
				id: headingTextField
				Kirigami.FormData.label: i18n("Heading:")
				Kirigami.FormData.checkable: true
				Kirigami.FormData.checked: plasmoid.configuration.showHeading
				Kirigami.FormData.onCheckedChanged: plasmoid.configuration.showHeading = Kirigami.FormData.checked
				Layout.fillWidth: true
				placeholderText: cfg_repoList.join(', ')
			}

			ConfigRadioButtonGroup {
				Kirigami.FormData.label: i18n("Issues:")
				configKey: "issueState"
				model: [
					{ value: "open", text: i18n("Open Issues") },
					{ value: "closed", text: i18n("Closed Issues") },
					{ value: "all", text: i18n("Open + Closed Issues") },
				]
			}

			MessageWidget {
				text: i18n("Every IP can only perform 60 API requests to GitHub per hour.\nEach repository listed is 1 request.")
				messageType: information
				visible: true
				closeButtonVisible: false
				Layout.fillWidth: true
				Layout.preferredWidth: units.gridUnit * 20
			}

			SpinBox {
				id: updateIntervalInMinutesSpinBox
				Kirigami.FormData.label: i18n("Update Every:")
				stepSize: 5
				minimumValue: 5
				maximumValue: 24 * 60
				suffix: i18nc("Polling interval in minutes", "min")
			}

			ConfigCheckBox {
				configKey: "showBackground"
				text: i18n("Desktop Widget: Show background")
			}
		}
	}
}
