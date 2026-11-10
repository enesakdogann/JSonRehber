import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

ApplicationWindow {
    id: window
    width: 400
    height: 650
    visible: true
    title: qsTr("JSON Rehber")

    ColumnLayout {               // elemanları alt alta dizer
        anchors.top: parent.top                      // ← centerIn yerine bu üçü
               anchors.topMargin: 20
               anchors.horizontalCenter: parent.horizontalCenter
        width: 280               // tüm formun genişliği
        spacing: 12              // elemanlar arası boşluk

        Label {
            text: "Yeni Kişi Ekle"
            font.pixelSize: 22
            font.bold: true
            Layout.alignment: Qt.AlignHCenter   // başlığı ortala
        }

        TextField {
            id: adField
            placeholderText: "Ad"
            Layout.fillWidth: true              // genişliği doldur
        }

        TextField {
            id: telefonField
            placeholderText: "Telefon"
            maximumLength: 11                   // max 11 haneli
            validator: RegularExpressionValidator { regularExpression: /[0-9]*/ }  // sadece rakam
            Layout.fillWidth: true
        }

        TextField {
            id: yasField
            placeholderText: "Yaş"
            Layout.fillWidth: true
            validator: IntValidator { bottom: 0; top: 150 }  // sadece 0-150 arası sayı
        }

        Button {
            id: kaydetButton
            text: "Kaydet"
            Layout.fillWidth: true
            enabled: adField.text !== "" && telefonField.text !== "" && yasField.text !== ""

            onClicked: {
                // 1) C++ fonksiyonunu çağır, sonucu (0, 1 veya 2) bir değişkene al
                var sonuc = kaydedici.kaydet(adField.text, telefonField.text, parseInt(yasField.text))

                // 2) Sonuca göre mesaj ve renk göster
                if (sonuc === 0) {
                    durumText.text = adField.text + " kaydedildi"
                    durumText.color = "green"
                    kisiListesi.model = kaydedici.kisileriGetir()  //ekranın hep yenilenmesini sağlayacak

                    // başarılıysa kutuları temizle
                    adField.text = ""
                    telefonField.text = ""
                    yasField.text = ""
                }
                else if (sonuc === 1) {
                    durumText.text = "Bu numara zaten kayıtlı"
                    durumText.color = "orange"
                }
                else {
                    durumText.text = "Dosya hatası!"
                    durumText.color = "red"
                }
            }
        }

        Label {
            id: durumText                       // sonuç mesajı burada görünür
            text: ""
            Layout.alignment: Qt.AlignHCenter
        }
        Label {
                   text: "Kayıtlı Kişiler"
                   font.pixelSize: 16
                   font.bold: true
                   Layout.topMargin: 10
               }

               ListView {
                   id: kisiListesi
                   Layout.fillWidth: true
                   Layout.preferredHeight: 250        // listenin yüksekliği
                   clip: true                         // taşan satırları gizle
                   spacing: 6
                   model: kaydedici.kisileriGetir()   // ← veriyi C++'tan al

                   delegate: Rectangle {              // ← her satırın kalıbı
                       width: kisiListesi.width
                       height: 50
                       radius: 6
                       color: "#f0f0f0"

                       Column {
                           anchors.verticalCenter: parent.verticalCenter
                           anchors.left: parent.left
                           anchors.leftMargin: 10

                           Text {
                               text: (index + 1) + ". " + modelData.ad
                               font.bold: true
                           }
                           Text {
                               text: modelData.telefon + "  •  " + modelData.yas + " yaş"
                               color: "gray"
                           }
                       }
                       Button {
                           id: silButton
                           text: "Sil"
                           anchors.right: parent.right
                           anchors.rightMargin: 8
                           anchors.verticalCenter: parent.verticalCenter

                           // Butonun içindeki yazı
                           contentItem: Text {
                               text: silButton.text
                               color: silButton.hovered ? "white" : "#c42b1c"   // üstteyken beyaz, değilken koyu kırmızı
                               font.bold: true
                               horizontalAlignment: Text.AlignHCenter
                               verticalAlignment: Text.AlignVCenter
                           }

                           // Butonun arka planı
                           background: Rectangle {
                               implicitWidth: 60
                               implicitHeight: 32
                               radius: 6
                               color: silButton.pressed ? "#c50f1f"            // basılıyken daha koyu kırmızı
                                    : silButton.hovered ? "#e81123"            // üstteyken Windows kırmızısı
                                    : "transparent"                            // normalde şeffaf


                           }

                           onClicked: {
                               if (kaydedici.sil(modelData.telefon)) {
                                   durumText.text = modelData.ad + " silindi"
                                   durumText.color = "gray"
                                   kisiListesi.model = kaydedici.kisileriGetir()
                               }
                           }
                       }
                   }
               }

    }   // ColumnLayout kapanışı
}       // ApplicationWindow kapanışı