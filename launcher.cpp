#include "launcher.h"
#include <QDebug>

Launcher::Launcher(QObject *parent) :
    QObject(parent), m_process(this) {

    connect(&m_process, SIGNAL(finished(int, QProcess::ExitStatus)), this, SLOT(processFinished(int, QProcess::ExitStatus)));
    connect(&m_process, SIGNAL(errorOccurred(QProcess::ProcessError error)), this, SLOT(processErrorOccurred(QProcess::ProcessError)));
}

void Launcher::launch(const QString &program, const QStringList &args) {
    if (m_process.state()==QProcess::Running)
        return;
    m_process.setProcessEnvironment(QProcessEnvironment::systemEnvironment());
    m_process.start(program, args);
    m_process.waitForStarted();
}

void Launcher::processFinished(int, QProcess::ExitStatus) {
    QByteArray bytes = m_process.readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    emit finished(output);
}

void Launcher::processErrorOccurred(QProcess::ProcessError) {
    emit failed();
}
