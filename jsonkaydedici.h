#ifndef JSONKAYDEDICI_H
#define JSONKAYDEDICI_H

#include <QObject>
#include<QString>


class JSonKaydedici : public QObject
{
    Q_OBJECT
public:
    explicit JSonKaydedici(QObject *parent = nullptr);
    Q_INVOKABLE int kaydet (const QString &ad , const QString &telefon, int yas);//bool yazmamazın nedeni iki farklı başarısızlık durumunu kontrol edeceğiz



signals:
private:
    QString m_dosyaYolu;


};


#endif // JSONKAYDEDICI_H
