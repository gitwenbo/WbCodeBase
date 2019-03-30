
def HOSTNAME = hostname
logbackParent = this
evaluate(org.springframework.util.ResourceUtils.getURL('classpath:vitamin/logback/logback-common.groovy').text)

logger('com.coupang', INFO)
enableJpaSqlLogger()

root(INFO, ['stdout'])