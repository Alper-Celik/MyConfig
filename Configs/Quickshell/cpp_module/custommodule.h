#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

class CustomModule : public QObject {
  Q_OBJECT
  QML_ELEMENT
  Q_PROPERTY(QString message READ message CONSTANT)

public:
  explicit CustomModule(QObject *parent = nullptr);

  QString message() const { return "Hello from C++ Module!"; }
};
