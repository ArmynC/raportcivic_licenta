#ifndef REPORTBRIDGE_H
#define REPORTBRIDGE_H

#include "dev/singleton.h"
#include <QObject>
#include <QUrl>

class ReportBridge : public QObject, public Singleton<ReportBridge>
{
    Q_OBJECT
    Q_PROPERTY(int selectedReportId READ selectedReportId WRITE setSelectedReportId NOTIFY selectedReportIdChanged)
    Q_PROPERTY(QString firstName READ firstName WRITE setFirstName NOTIFY firstNameChanged)
    Q_PROPERTY(QString lastName READ lastName WRITE setLastName NOTIFY lastNameChanged)
    Q_PROPERTY(QString personalNumericCode READ personalNumericCode WRITE setPersonalNumericCode NOTIFY personalNumericCodeChanged)
    Q_PROPERTY(QString contactEmail READ contactEmail WRITE setContactEmail NOTIFY contactEmailChanged)
    Q_PROPERTY(QString phone READ phone WRITE setPhone NOTIFY phoneChanged)
    Q_PROPERTY(QString county READ county WRITE setCounty NOTIFY countyChanged)
    Q_PROPERTY(QString city READ city WRITE setCity NOTIFY cityChanged)
    Q_PROPERTY(QString street READ street WRITE setStreet NOTIFY streetChanged)
    Q_PROPERTY(QString building READ building WRITE setBuilding NOTIFY buildingChanged)
    Q_PROPERTY(QString entrance READ entrance WRITE setEntrance NOTIFY entranceChanged)
    Q_PROPERTY(QString apartment READ apartment WRITE setApartment NOTIFY apartmentChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QString eventLocation READ eventLocation WRITE setEventLocation NOTIFY eventLocationChanged)
    Q_PROPERTY(QString currentDate READ currentDate WRITE setCurrentDate NOTIFY currentDateChanged)
    Q_PROPERTY(QString genderText READ genderText WRITE setGenderText NOTIFY genderTextChanged)
    Q_PROPERTY(QString googleMapsLink READ googleMapsLink WRITE setGoogleMapsLink NOTIFY googleMapsLinkChanged)
    Q_PROPERTY(QString reportText READ reportText WRITE setReportText NOTIFY reportTextChanged)
    Q_PROPERTY(QList<QString> attachedImages READ attachedImages WRITE setAttachedImages NOTIFY attachedImagesChanged)
    Q_PROPERTY(QList<QString> attachedDocuments READ attachedDocuments WRITE setAttachedDocuments NOTIFY attachedDocumentsChanged)


public:
    explicit ReportBridge(QObject *parent = nullptr);
    ~ReportBridge();

    int selectedReportId() const;
    void setSelectedReportId(int id);

    QString firstName() const;
    void setFirstName(const QString &firstName);

    QString lastName() const;
    void setLastName(const QString &lastName);

    QString personalNumericCode() const;
    void setPersonalNumericCode(const QString &personalNumericCode);

    QString contactEmail() const;
    void setContactEmail(const QString &contactEmail);

    QString phone() const;
    void setPhone(const QString &phone);

    QString county() const;
    void setCounty(const QString &county);

    QString city() const;
    void setCity(const QString &city);

    QString street() const;
    void setStreet(const QString &street);

    QString building() const;
    void setBuilding(const QString &building);

    QString entrance() const;
    void setEntrance(const QString &entrance);

    QString apartment() const;
    void setApartment(const QString &apartment);

    QString description() const;
    void setDescription(const QString &description);

    QString eventLocation() const;
    void setEventLocation(const QString &eventLocation);

    QString currentDate() const;
    void setCurrentDate(const QString &currentDate);

    QString genderText() const;
    void setGenderText(const QString &genderText);

    QString googleMapsLink() const;
    void setGoogleMapsLink(const QString &googleMapsLink);

    QString reportText() const;
    void setReportText(const QString &reportText);

    QList<QString> attachedImages() const;
    Q_INVOKABLE void setAttachedImages(const QList<QString>& attachedImages);

    QList<QString> attachedDocuments() const;
    Q_INVOKABLE void setAttachedDocuments(const QList<QString>& attachedDocuments);

    bool hasAttachedImages() const;
    bool hasAttachedDocuments() const;

signals:
    void selectedReportIdChanged();
    void firstNameChanged();
    void lastNameChanged();
    void personalNumericCodeChanged();
    void contactEmailChanged();
    void phoneChanged();
    void countyChanged();
    void cityChanged();
    void streetChanged();
    void buildingChanged();
    void entranceChanged();
    void apartmentChanged();
    void descriptionChanged();
    void eventLocationChanged();
    void currentDateChanged();
    void genderTextChanged();
    void googleMapsLinkChanged();
    void reportTextChanged();
    void attachedImagesChanged();
    void attachedDocumentsChanged();


private:
    int m_selectedReportId;
    QString m_firstName;
    QString m_lastName;
    QString m_personalNumericCode;
    QString m_contactEmail;
    QString m_phone;
    QString m_county;
    QString m_city;
    QString m_street;
    QString m_building;
    QString m_entrance;
    QString m_apartment;
    QString m_description;
    QString m_eventLocation;
    QString m_currentDate;
    QString m_genderText;
    QString m_googleMapsLink;
    QString m_reportText;
    QList<QString> m_attachedImages;
    QList<QString> m_attachedDocuments;
};

#endif // REPORTBRIDGE_H
