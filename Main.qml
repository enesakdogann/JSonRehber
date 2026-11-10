import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

ApplicationWindow {
    id: window
    width: 400
    height: 450
    visible: true
    title: qsTr("JSON Rehber")

    ColumnLayout {               // elemanları alt alta dizer
        anchors.centerIn: parent // pencerenin ortasına koyar
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

    }   // ColumnLayout kapanışı
}       // ApplicationWindow kapanışı