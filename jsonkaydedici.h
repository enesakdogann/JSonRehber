#ifndef JSONKAYDEDICI_H
#define JSONKAYDEDICI_H

#include <QObject>
#include<QString>
#include <QVariantList>
#include <QJsonArray>



class JSonKaydedici : public QObject
{
    Q_OBJECT
public:
    explicit JSonKaydedici(QObject *parent = nullptr);
    Q_INVOKABLE int kaydet (const QString &ad , const QString &telefon, int yas);//bool yazmamazın nedeni iki farklı başarısızlık durumunu kontrol edeceğiz
    Q_INVOKABLE QVariantList kisileriGetir();   //  QML'e kişi listesini verir
    Q_INVOKABLE bool sil(const QString &telefon);



signals:
private:
    QString m_dosyaYolu;
    QJsonArray dosyayiOku();
      bool dosyayaYaz(const QJsonArray &liste);


};


#endif // JSONKAYDEDICI_H
