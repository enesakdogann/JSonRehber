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
    // 1) OKU: eski kayıtları al (dosya yoksa boş liste gelir)
    QJsonArray liste = dosyayiOku();

    // 2) KONTROL ET: bu telefon listede var mı?
    for (const QJsonValue &deger : liste) {
        QJsonObject kisi = deger.toObject();
        if (kisi["telefon"].toString() == telefon)
            return 1;                              // bulundu → kaydetme, çık
    }

    // 3) EKLE: yeni kişiyi oluştur ve listeye koy
    QJsonObject yeniKisi;
    yeniKisi["ad"] = ad;
    yeniKisi["telefon"] = telefon;
    yeniKisi["yas"] = yas;
    liste.append(yeniKisi);

    // 4) YAZ: listenin tamamını dosyaya yaz
    if (!dosyayaYaz(liste))
        return 2;   // dosya hatası
    return 0;       // başarılı                                    // başarılı
}
// Dosyayı okuyup içindeki listeyi döndürür (dosya yoksa boş liste)
QJsonArray JSonKaydedici::dosyayiOku()
{
    QFile dosya(m_dosyaYolu);
    if (!dosya.open(QIODevice::ReadOnly))
        return QJsonArray();   // dosya yok → boş liste

    return QJsonDocument::fromJson(dosya.readAll()).array();
}

// QML'e kişi listesini verir
QVariantList JSonKaydedici::kisileriGetir()
{
    return dosyayiOku().toVariantList();   // QJsonArray → QML'in anladığı liste
}
// Listeyi dosyaya yazar, başarılıysa true döner
bool JSonKaydedici::dosyayaYaz(const QJsonArray &liste)
{
    QFile dosya(m_dosyaYolu);
    if (!dosya.open(QIODevice::WriteOnly))
        return false;

    dosya.write(QJsonDocument(liste).toJson(QJsonDocument::Indented));
    return true;
}

// Telefonu eşleşen kişiyi siler
bool JSonKaydedici::sil(const QString &telefon)
{
    QJsonArray liste = dosyayiOku();

    for (int i = 0; i < liste.size(); i++) {               // 0'dan son elemana kadar
        if (liste[i].toObject()["telefon"].toString() == telefon) {
            liste.removeAt(i);                              // i. sıradaki kişiyi çıkar
            return dosyayaYaz(liste);                       // yaz ve sonucu döndür
        }
    }
    return false;   // bu numarayla kimse bulunamadı
}