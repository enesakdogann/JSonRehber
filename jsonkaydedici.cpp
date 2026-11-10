#include "jsonkaydedici.h"
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QJsonDocument>   // JSON dosyasının tamamı
#include <QJsonArray>      // [ ] liste
#include <QJsonObject>     // { } tek kişi
#include <QDebug>

JSonKaydedici::JSonKaydedici(QObject *parent)
    : QObject{parent}

{ QString klasor = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    m_dosyaYolu = QDir(klasor).filePath("rehber.json");
    qDebug() << "JSON dosyasi:" << m_dosyaYolu;
}
int JSonKaydedici::kaydet(const QString &ad, const QString &telefon, int yas)
{
    QFile dosya(m_dosyaYolu);

        QJsonArray liste;
    //oku dosya kayıtlatları varsa eskisinin al
    if(dosya.open(QIODevice::ReadOnly)){
        liste=QJsonDocument::fromJson(dosya.readAll()).array();
        dosya.close();




    }
    // 2) KONTROL ET: bu telefon listede var mı?
    for (const QJsonValue &deger : liste) {        // listedeki her kişiyi tek tek gez
        QJsonObject kisi = deger.toObject();       // değeri { } nesnesine çevir
        if (kisi["telefon"].toString() == telefon)
            return 1;                              // bulundu → kaydetme, çık
    }
    // 3) EKLE: yeni kişiyi oluştur ve listeye koy
    QJsonObject yeniKisi;
    yeniKisi["ad"] = ad;
    yeniKisi["telefon"] = telefon;
    yeniKisi["yas"] = yas;                         // int olduğu için JSON'a SAYI olarak yazılır
    liste.append(yeniKisi);

    // 4) YAZ: listenin tamamını dosyaya yaz
    if (!dosya.open(QIODevice::WriteOnly))
        return 2;                                  // dosya hatası

    dosya.write(QJsonDocument(liste).toJson(QJsonDocument::Indented));
    return 0;                                      // başarılı

}