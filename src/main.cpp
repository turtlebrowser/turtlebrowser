#include "ApplicationState.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <qtwebengineglobal.h>
#include <QQmlContext>

int main(int argc, char *argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
  QApplication app(argc, argv);

  QtWebEngine::initialize();

  turtle_browser::ApplicationState applicationState;

  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("licenseModelWebView", applicationState.searchModelWebLicenses());
  engine.rootContext()->setContextProperty("licenseModelToolkit", applicationState.searchModelToolkitLicenses());
  engine.rootContext()->setContextProperty("licenseModelPlatform", applicationState.searchModelPlatformLicenses());
  engine.rootContext()->setContextProperty("licenseModelAll", applicationState.searchModelAllLicenses());
  engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
  QMetaObject::invokeMethod(engine.rootObjects().first(), "start");

  return app.exec();
}
