#include "ReportBridge.h"

ReportBridge::ReportBridge(QObject *parent) : QObject(parent), m_selectedReportId(-1)
{
}

ReportBridge::~ReportBridge()
{
}

int ReportBridge::selectedReportId() const
{
    return m_selectedReportId;
}

void ReportBridge::setSelectedReportId(int id)
{
    if (m_selectedReportId != id) {
        m_selectedReportId = id;
        emit selectedReportIdChanged();
    }
}

QString ReportBridge::firstName() const
{
    return m_firstName;
}

void ReportBridge::setFirstName(const QString &firstName)
{
    if (m_firstName != firstName) {
        m_firstName = firstName;
        emit firstNameChanged();
    }
}

QString ReportBridge::lastName() const
{
    return m_lastName;
}

void ReportBridge::setLastName(const QString &lastName)
{
    if (m_lastName != lastName) {
        m_lastName = lastName;
        emit lastNameChanged();
    }
}

QString ReportBridge::personalNumericCode() const
{
    return m_personalNumericCode;
}

void ReportBridge::setPersonalNumericCode(const QString &personalNumericCode)
{
    if (m_personalNumericCode != personalNumericCode) {
        m_personalNumericCode = personalNumericCode;
        emit personalNumericCodeChanged();
    }
}

QString ReportBridge::contactEmail() const
{
    return m_contactEmail;
}

void ReportBridge::setContactEmail(const QString &contactEmail)
{
    if (m_contactEmail != contactEmail) {
        m_contactEmail = contactEmail;
        emit contactEmailChanged();
    }
}

QString ReportBridge::phone() const
{
    return m_phone;
}

void ReportBridge::setPhone(const QString &phone)
{
    if (m_phone != phone) {
        m_phone = phone;
        emit phoneChanged();
    }
}

QString ReportBridge::county() const
{
    return m_county;
}

void ReportBridge::setCounty(const QString &county)
{
    if (m_county != county) {
        m_county = county;
        emit countyChanged();
    }
}

QString ReportBridge::city() const
{
    return m_city;
}

void ReportBridge::setCity(const QString &city)
{
    if (m_city != city) {
        m_city = city;
        emit cityChanged();
    }
}

QString ReportBridge::street() const
{
    return m_street;
}

void ReportBridge::setStreet(const QString &street)
{
    if (m_street != street) {
        m_street = street;
        emit streetChanged();
    }
}

QString ReportBridge::building() const
{
    return m_building;
}

void ReportBridge::setBuilding(const QString &building)
{
    if (m_building != building) {
        m_building = building;
        emit buildingChanged();
    }
}

QString ReportBridge::entrance() const
{
    return m_entrance;
}

void ReportBridge::setEntrance(const QString &entrance)
{
    if (m_entrance != entrance) {
        m_entrance = entrance;
        emit entranceChanged();
    }
}

QString ReportBridge::apartment() const
{
    return m_apartment;
}

void ReportBridge::setApartment(const QString &apartment)
{
    if (m_apartment != apartment) {
        m_apartment = apartment;
        emit apartmentChanged();
    }
}

QString ReportBridge::description() const
{
    return m_description;
}

void ReportBridge::setDescription(const QString &description)
{
    if (m_description != description) {
        m_description = description;
        emit descriptionChanged();
    }
}

QString ReportBridge::eventLocation() const
{
    return m_eventLocation;
}

void ReportBridge::setEventLocation(const QString &eventLocation)
{
    if (m_eventLocation != eventLocation) {
        m_eventLocation = eventLocation;
        emit eventLocationChanged();
    }
}

QString ReportBridge::currentDate() const
{
    return m_currentDate;
}

void ReportBridge::setCurrentDate(const QString &currentDate)
{
    if (m_currentDate != currentDate) {
        m_currentDate = currentDate;
        emit currentDateChanged();
    }
}

QString ReportBridge::genderText() const
{
    return m_genderText;
}

void ReportBridge::setGenderText(const QString &genderText)
{
    if (m_genderText != genderText) {
        m_genderText = genderText;
        emit genderTextChanged();
    }
}


QString ReportBridge::googleMapsLink() const
{
    return m_googleMapsLink;
}

void ReportBridge::setGoogleMapsLink(const QString &googleMapsLink)
{
    if (m_googleMapsLink != googleMapsLink) {
        m_googleMapsLink = googleMapsLink;
        emit googleMapsLinkChanged();
    }
}

QString ReportBridge::reportText() const
{
    return m_reportText;
}

void ReportBridge::setReportText(const QString &reportText)
{
    if (m_reportText != reportText) {
        m_reportText = reportText;
        emit reportTextChanged();
    }
}

QList<QString> ReportBridge::attachedImages() const
{
    return m_attachedImages;
}

void ReportBridge::setAttachedImages(const QList<QString>& attachedImages)
{
    if (m_attachedImages != attachedImages) {
        m_attachedImages = attachedImages;
        emit attachedImagesChanged();
    }
}

QList<QString> ReportBridge::attachedDocuments() const
{
    return m_attachedDocuments;
}

void ReportBridge::setAttachedDocuments(const QList<QString>& attachedDocuments)
{
    if (m_attachedDocuments != attachedDocuments) {
        m_attachedDocuments = attachedDocuments;
        emit attachedDocumentsChanged();
    }
}

bool ReportBridge::hasAttachedImages() const
{
    return !m_attachedImages.isEmpty();
}

bool ReportBridge::hasAttachedDocuments() const
{
    return !m_attachedDocuments.isEmpty();
}
