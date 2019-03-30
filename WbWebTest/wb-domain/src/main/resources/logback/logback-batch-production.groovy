import static ch.qos.logback.classic.Level.DEBUG
import static ch.qos.logback.classic.Level.INFO

def HOSTNAME = hostname
logbackParent = this
evaluate(org.springframework.util.ResourceUtils.getURL('classpath:vitamin/logback/logback-common.groovy').text)

logger('com.coupang', INFO)
logger('com.google.code.ssm', WARN)

gelfErrorLogger('post-dedup-batch')
batchErrorFile('post-dedup-batch')

dailyRollingFileAppender(name: 'server.log', file: '/post_dedup_batch/batch.log',
		pattern: '%-5level %d{yyyy-MM-dd HH:mm:ss} [%thread] %class{36}.%method:%line - %msg [%mdc]%n',
		maxHistory: 5,
		compress: false
)
root(INFO, ['batchErrorFile', 'stdout', 'gelfError', 'serverLog', 'gelfApiTracking', 'server.log'])

dailyRollingFileAppender(name: 'rabbitmq_producer.log', file: '/post_dedup_batch/rabbitmq_producer.log',
		pattern: '%d{yyyy-MM-dd HH:mm:ss} - AMQP - [%msg]%n',
		maxHistory: 30,
		compress: false
)
logbackParent.logger('com.coupang.rabbitmq.producer.Producer', DEBUG, ['rabbitmq_producer.log'], false)

dailyRollingFileAppender(name: 'matching_api.log', file: '/post_dedup_batch/matching_api.log',
		pattern: '%d{yyyy-MM-dd HH:mm:ss} - MATCHING_API - [%msg]%n',
		maxHistory: 5,
		compress: false
)
logbackParent.logger('com.coupang.postdedup.domain.apiwrapper.ItemMatchingHandler', INFO, ['matching_api.log', 'stdout'], false)
logbackParent.logger('com.coupang.postdedup.domain.business.item.imagematching.ImageMatchingService', INFO, ['matching_api.log', 'stdout'], false)
